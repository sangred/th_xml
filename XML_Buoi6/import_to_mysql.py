#!/usr/bin/env python3
"""
import_to_mysql.py

Usage:
  python import_to_mysql.py --xml catalog.xml --xsd catalog.xsd \
      --host localhost --user root --password secret --database shopdb

Script will:
 - Validate XML with XSD, print specific validation errors if any
 - Parse XML using lxml and XPath, extract categories and products
 - Connect to MySQL, create tables if missing
 - Insert / update categories and products (products reference categoryRef)
"""

import argparse
import sys
import os
import xmlschema
from lxml import etree
import mysql.connector
from mysql.connector import errorcode

def validate_xml(xsd_path, xml_path):
    """Validate xml against xsd. Return (is_valid, errors_list)"""
    schema = xmlschema.XMLSchema(xsd_path)
    errors = []
    # Use iter_errors to collect all errors (gives detailed info)
    for err in schema.iter_errors(xml_path):
        # err is XMLSchemaValidationError-like object, has .message and .path and .line
        msg = getattr(err, "message", str(err))
        path = getattr(err, "path", None)
        line = getattr(err, "line", None)
        column = getattr(err, "column", None)
        errors.append({
            "message": msg,
            "path": path,
            "line": line,
            "column": column
        })
    return (len(errors) == 0, errors)

def parse_xml(xml_path):
    """Parse xml and return lxml root element"""
    parser = etree.XMLParser(remove_blank_text=True)
    tree = etree.parse(xml_path, parser)
    return tree.getroot()

def ensure_tables(cursor):
    """Create tables Categories and Products if not exists (MySQL)"""
    create_categories = """
    CREATE TABLE IF NOT EXISTS Categories (
        CategoryID VARCHAR(64) NOT NULL PRIMARY KEY,
        CategoryName VARCHAR(255) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    """
    create_products = """
    CREATE TABLE IF NOT EXISTS Products (
        ProductID VARCHAR(64) NOT NULL PRIMARY KEY,
        ProductName VARCHAR(255) NOT NULL,
        Price DECIMAL(12,2),
        Currency VARCHAR(16),
        Stock INT,
        CategoryRef VARCHAR(64),
        FOREIGN KEY (CategoryRef) REFERENCES Categories(CategoryID)
            ON DELETE SET NULL ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    """
    cursor.execute(create_categories)
    cursor.execute(create_products)

def upsert_category(cursor, cid, cname):
    sql = """
    INSERT INTO Categories (CategoryID, CategoryName)
    VALUES (%s, %s)
    ON DUPLICATE KEY UPDATE CategoryName = VALUES(CategoryName)
    """
    cursor.execute(sql, (cid, cname))

def upsert_product(cursor, pid, pname, price, currency, stock, catref):
    sql = """
    INSERT INTO Products (ProductID, ProductName, Price, Currency, Stock, CategoryRef)
    VALUES (%s, %s, %s, %s, %s, %s)
    ON DUPLICATE KEY UPDATE
        ProductName = VALUES(ProductName),
        Price = VALUES(Price),
        Currency = VALUES(Currency),
        Stock = VALUES(Stock),
        CategoryRef = VALUES(CategoryRef)
    """
    cursor.execute(sql, (pid, pname, price, currency, stock, catref))

def extract_and_insert(root, db_cursor):
    # Expect structure:
    # /catalog/categories/category[@id] -> text = name
    # /catalog/products/product[@id @categoryRef] children name, price(currency attr), stock
    # Use XPath (lxml)
    ns = {}  # no namespaces in sample; if you have, adapt here

    # Categories
    cats = root.xpath("/catalog/categories/category", namespaces=ns)
    for c in cats:
        cid = c.get("id")
        if cid is None:
            print("Warning: category without id attribute; skipping.")
            continue
        cname = (c.text or "").strip()
        upsert_category(db_cursor, cid, cname)

    # Products
    prods = root.xpath("/catalog/products/product", namespaces=ns)
    for p in prods:
        pid = p.get("id")
        catref = p.get("categoryRef")
        if not pid:
            print("Warning: product without id attribute; skipping.")
            continue
        # name
        name_el = p.find("name")
        pname = (name_el.text or "").strip() if name_el is not None else None
        # price element with currency attribute and numeric text
        price_el = p.find("price")
        price = None
        currency = None
        if price_el is not None:
            txt = (price_el.text or "").strip()
            try:
                price = float(txt) if txt != "" else None
            except ValueError:
                # try to clean commas
                try:
                    price = float(txt.replace(",", ""))
                except Exception:
                    price = None
            currency = price_el.get("currency")
        # stock
        stock_el = p.find("stock")
        stock = None
        if stock_el is not None:
            try:
                stock = int((stock_el.text or "0").strip())
            except ValueError:
                stock = None

        upsert_product(db_cursor, pid, pname, price, currency, stock, catref)

def main():
    parser = argparse.ArgumentParser(description="Validate XML with XSD and import to MySQL")
    parser.add_argument("--xml", required=True, help="Path to XML file")
    parser.add_argument("--xsd", required=True, help="Path to XSD file")
    parser.add_argument("--host", required=True, help="MySQL host")
    parser.add_argument("--user", required=True, help="MySQL user")
    parser.add_argument("--password", required=True, help="MySQL password")
    parser.add_argument("--database", required=True, help="MySQL database")
    parser.add_argument("--port", type=int, default=3306, help="MySQL port (default 3306)")
    args = parser.parse_args()

    xml_path = args.xml
    xsd_path = args.xsd

    if not os.path.isfile(xml_path):
        print(f"ERROR: XML file not found: {xml_path}")
        sys.exit(1)
    if not os.path.isfile(xsd_path):
        print(f"ERROR: XSD file not found: {xsd_path}")
        sys.exit(1)

    print("1) Validating XML against XSD...")
    valid, errors = validate_xml(xsd_path, xml_path)
    if not valid:
        print("❌ XML KHÔNG HỢP LỆ với XSD. Các lỗi chi tiết:")
        for i, e in enumerate(errors, start=1):
            lineinfo = f" line={e.get('line')}" if e.get('line') else ""
            colinfo = f" col={e.get('column')}" if e.get('column') else ""
            pathinfo = f" path={e.get('path')}" if e.get('path') else ""
            print(f"  {i}. message: {e.get('message')}{lineinfo}{colinfo}{pathinfo}")
        sys.exit(2)
    print("✅ XML hợp lệ với XSD. Tiến hành parse và lưu vào MySQL...")

    # Parse XML
    root = parse_xml(xml_path)

    # Connect to MySQL
    dbconf = {
        "host": args.host,
        "user": args.user,
        "password": args.password,
        "database": args.database,
        "port": args.port,
        "charset": "utf8mb4"
    }
    try:
        conn = mysql.connector.connect(**dbconf)
    except mysql.connector.Error as err:
        print("ERROR connecting to MySQL:", err)
        sys.exit(3)

    try:
        cursor = conn.cursor()
        ensure_tables(cursor)
        # Start transaction
        conn.start_transaction()
        extract_and_insert(root, cursor)
        conn.commit()
        print("✅ Dữ liệu đã được chèn / cập nhật vào MySQL thành công.")
    except mysql.connector.Error as db_err:
        print("Database error:", db_err)
        conn.rollback()
        print("Rolled back transaction.")
    except Exception as e:
        print("Unexpected error:", e)
        conn.rollback()
    finally:
        try:
            cursor.close()
        except:
            pass
        conn.close()


if __name__ == "__main__":
    main()
