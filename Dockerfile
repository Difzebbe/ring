FROM python:3.11-bookworm

# Lägg till Raspberry Pi OS package repo (nödvändigt för python3-picamera2)
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    && curl -sSL https://archive.raspberrypi.org/debian/raspberrypi.gpg.key | gpg --dearmor -o /usr/share/keyrings/raspberrypi-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/raspberrypi-archive-keyring.gpg] http://archive.raspberrypi.org/debian/ bookworm main" > /etc/apt/sources.list.d/raspi.list

# Installera libcamera + Picamera2 + dependencies
RUN apt-get update && apt-get install -y \
    python3-picamera2 \
    libcamera-dev \
    libcamera-apps \
    libatlas-base-dev \
    && apt-get clean

# Applikation
WORKDIR /app
COPY . /app

# Installera Python-dependencies, hoppa över fel
RUN pip3 install --no-cache-dir -r requirements.txt || true

CMD ["python3", "ring.py"]
