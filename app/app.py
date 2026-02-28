from flask import Flask
import os
import socket
from datetime import datetime

app = Flask(__name__)

@app.route("/")
def home():
    return f"""
    <h1>✅ DevOps CI/CD Project Running</h1>
    <p><b>Time:</b> {datetime.utcnow()} UTC</p>
    <p><b>Hostname:</b> {socket.gethostname()}</p>
    <p><b>Version:</b> {os.getenv('APP_VERSION', 'v1')}</p>
    """

@app.route("/health")
def health():
    return {"status": "ok"}

if __name__ == "__main__":
    # IMPORTANT: host=0.0.0.0 allows access from outside the container
    app.run(host="0.0.0.0", port=5000)
