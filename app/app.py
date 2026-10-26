import socket, time
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.get("/health")
def health():
    return jsonify(estado="vivo", version="1.1", pod=socket.gethostname())

@app.get("/ready")
def ready():
    return jsonify(estado="listo", pod=socket.gethostname())

@app.get("/signos")
def signos():
    cama = request.args.get("cama", "UCI-01")
    return jsonify(cama=cama, fc=72, spo2=97, temp=36.8,
                   pod=socket.gethostname(), ts=time.time())

@app.get("/carga")
def carga():
    n = int(request.args.get("n", "300000"))
    total = 0
    for i in range(n):
        total += i * i
    return jsonify(resultado=total, pod=socket.gethostname())
