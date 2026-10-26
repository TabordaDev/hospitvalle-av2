# Etapa 1: descargar y compilar las dependencias
FROM python:3.11-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt

# Etapa 2: imagen final, liviana y sin herramientas de compilación
FROM python:3.11-slim
RUN useradd --create-home --uid 10001 hospital
WORKDIR /app
RUN --mount=type=bind,from=builder,source=/wheels,target=/wheels \
    pip install --no-cache-dir --no-index --find-links=/wheels flask gunicorn
COPY app.py .
USER hospital
EXPOSE 8080
CMD ["gunicorn", "-b", "0.0.0.0:8080", "-w", "2", "app:app"]
