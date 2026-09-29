FROM python:3.14.7-slim

# Instalar uv desde la imagen oficial
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Instalar dependencias del sistema del sistema para Tesseract OCR

RUN apt-get update && apt-get install -y --no-install-recommends \
    tesseract-ocr \
    tesseract-ocr-spa \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

#Copiar archivos de dependencias e instalarlas
COPY pyproject.toml uv.lock* ./
RUN uv sync --no-install-project

#Copiar codigo fuente
COPY . .

#Asegurar que los binarios del venv esten en el path
ENV PATH = "/app/.venv/bin:$PATH"

CMD ["granian", "--interface", "asgi", "--host", "0.0.0.0", "--port", "8000", "proyecto_ocr.main:app"]
