from flask import Flask
from prometheus_client import Counter, generate_latest
from prometheus_client import start_http_server

app = Flask(__name__)
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP Requests')


@app.route('/')
def hello():
    REQUEST_COUNT.inc()
    return 'Hello, World!'

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': 'text/plain; charset=utf-8'}

