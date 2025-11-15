FROM python:3.11-bookworm

# Installera Picamera2 och nödvändiga systempaket
RUN apt-get update && apt-get install -y \
    python3-picamera2 \
    libcamera-dev \
    libcamera-apps \
    libatlas-base-dev \
    && apt-get clean

WORKDIR /app

COPY . /app

RUN pip3 install --no-cache-dir -r requirements.txt || true

CMD ["python3", "ring.py"]
