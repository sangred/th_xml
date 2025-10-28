import requests
import json
from jsonschema import validate, ValidationError

# --- Hàm dùng để kiểm tra dữ liệu với schema ---
def validate_json(data, schema_path):
    with open(schema_path, "r", encoding="utf-8") as f:
        schema = json.load(f)
    try:
        validate(instance=data, schema=schema)
        print("✅ Dữ liệu hợp lệ theo schema!\n")
    except ValidationError as e:
        print("❌ Dữ liệu KHÔNG hợp lệ!")
        print("Lỗi:", e.message)
        print()


# --- 1. Kiểm tra API /api/book ---
print("📘 Kiểm tra API: /api/book")
book_res = requests.get("http://127.0.0.1:5000/api/book")
book_data = book_res.json()
print(json.dumps(book_data, indent=2, ensure_ascii=False))
validate_json(book_data, "bai1_schema.json")


# --- 2. Kiểm tra API /api/user/<username> ---
print("👤 Kiểm tra API: /api/user/minh123")
user_res = requests.get("http://127.0.0.1:5000/api/user/minh123")
user_data = user_res.json()
print(json.dumps(user_data, indent=2, ensure_ascii=False))
validate_json({"users": [user_data]}, "bai2_schema.json")  # bọc lại theo schema


# --- 3. Kiểm tra API /api/subtract ---
print("➖ Kiểm tra API: /api/subtract")
payload = {"a": 15, "b": 4}
sub_res = requests.post("http://127.0.0.1:5000/api/subtract", json=payload)
sub_data = sub_res.json()
print(json.dumps(sub_data, indent=2, ensure_ascii=False))

# Tự định nghĩa schema phép trừ
subtract_schema = {
    "type": "object",
    "properties": {
        "a": {"type": "number"},
        "b": {"type": "number"},
        "result": {"type": "number"}
    },
    "required": ["a", "b", "result"]
}

# validate_json(sub_data, None)
try:
    validate(instance=sub_data, schema=subtract_schema)
    print("✅ Phép trừ hợp lệ!\n")
except ValidationError as e:
    print("❌ Lỗi phép trừ:", e.message)
