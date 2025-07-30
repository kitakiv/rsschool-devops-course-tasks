from flask import Flask
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time

app = Flask(__name__)

REQUEST_COUNT = Counter('flask_app_requests_total', 'Total HTTP Requests', ['method', 'endpoint'])
REQUEST_LATENCY = Histogram('flask_app_request_duration_seconds', 'Request duration', ['endpoint'])

@app.route('/')
def index():
    start_time = time.time()
    REQUEST_COUNT.labels(method='GET', endpoint='/').inc()
    REQUEST_LATENCY.labels(endpoint='/').observe(time.time() - start_time)
    return "Hello, World!"

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

