# build image

FROM python:3.11-slim as builder

ENV PYTHONDONTWRITEBYCODE=1 \
    PYTHONBUFFERED=1

# SET WORKING DIRECTORY

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libffi-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt


FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN adduser --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

COPY --from=builder /install /usr/local
COPY --from=builder /app/requirements.txt .

COPY app.py .
COPY script.sh .

ENV PORT=5000
ENV APP_USER="DockerUser"

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:${PORT}/ || exit 1

CMD ["python", "app.py"]

