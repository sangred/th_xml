import xmlschema
import xml.etree.ElementTree as ET
import sqlite3

# Kiểm tra XML hợp lệ với XSD
schema = xmlschema.XMLSchema('catalog.xsd')
if not schema.is_valid('catalog.xml'):
    print(" File XML không hợp lệ với XSD")
    exit()
else:
    print(" File XML hợp lệ")

#  Đọc XML
tree = ET.parse('catalog.xml')
root = tree.getroot()

#  Kết nối DB (tạo tạm SQLite)
conn = sqlite3.connect('ecommerce.db')
cur = conn.cursor()

# Tạo bảng nếu chưa có
cur.execute('''
CREATE TABLE IF NOT EXISTS Categories (
    CategoryID TEXT PRIMARY KEY,
    CategoryName TEXT
)
''')

cur.execute('''
CREATE TABLE IF NOT EXISTS Products (
    ProductID TEXT PRIMARY KEY,
    ProductName TEXT,
    Price REAL,
    Currency TEXT,
    Stock INTEGER,
    CategoryRef TEXT,
    FOREIGN KEY (CategoryRef) REFERENCES Categories(CategoryID)
)
''')

# Chèn / cập nhật Categories
for cat in root.find('categories'):
    cid = cat.attrib['id']
    name = cat.text
    cur.execute('''
        INSERT INTO Categories (CategoryID, CategoryName)
        VALUES (?, ?)
        ON CONFLICT(CategoryID) DO UPDATE SET CategoryName=excluded.CategoryName
    ''', (cid, name))

#  Chèn / cập nhật Products
for prod in root.find('products'):
    pid = prod.attrib['id']
    cname = prod.find('name').text
    price = float(prod.find('price').text)
    currency = prod.find('price').attrib['currency']
    stock = int(prod.find('stock').text)
    catref = prod.attrib['categoryRef']

    cur.execute('''
        INSERT INTO Products (ProductID, ProductName, Price, Currency, Stock, CategoryRef)
        VALUES (?, ?, ?, ?, ?, ?)
        ON CONFLICT(ProductID) DO UPDATE SET
            ProductName=excluded.ProductName,
            Price=excluded.Price,
            Currency=excluded.Currency,
            Stock=excluded.Stock,
            CategoryRef=excluded.CategoryRef
    ''', (pid, cname, price, currency, stock, catref))

conn.commit()
print("✅ Dữ liệu đã được chèn hoặc cập nhật thành công.")
conn.close()
