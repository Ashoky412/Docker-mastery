from flask import Flask
import os

app = Flask(__name__)
@app.route("/")
def hello():
    return f"Hello {os.getenv('APP_USER', 'world')}!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", 5000)))


