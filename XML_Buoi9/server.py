from flask import Flask, jsonify, request
import json

app = Flask(__name__)

# Đọc dữ liệu từ file JSON
with open("bai1.json", "r", encoding="utf-8") as f:
    book_data = json.load(f)

with open("bai2.json", "r", encoding="utf-8") as f:
    users_data = json.load(f)


@app.route("/")
def home():
    return "Xin chào từ Flask trên mọi địa chỉ IP!"


# -------- GET /api/book --------
@app.route("/api/book", methods=["GET"])
def get_book():
    return jsonify(book_data)


# -------- GET /api/user/<username> --------
@app.route("/api/user/<username>", methods=["GET"])
def get_user(username):
    for user in users_data["users"]:
        if user["username"] == username:
            return jsonify(user)
    return jsonify({"error": "User not found"}), 404


# -------- POST /api/subtract --------
@app.route("/api/subtract", methods=["POST"])
def subtract():
    data = request.get_json()
    try:
        a = data.get("a")
        b = data.get("b")
        result = a - b
        return jsonify({"a": a, "b": b, "result": result})
    except Exception as e:
        return jsonify({"error": str(e)}), 400


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
