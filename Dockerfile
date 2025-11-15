FROM python:3.11-bookworm

# By default skip installing Raspberry Pi specific camera packages so
# you can build on non-Pi hosts. To install camera packages, build with:
#   docker build --build-arg INSTALL_CAMERA=true -t ring-app .

ARG INSTALL_CAMERA=false

# Lägg till Raspberry Pi OS package repo (endast använd om INSTALL_CAMERA=true)
RUN apt-get update && apt-get install -y \
        curl \
        gnupg \
        && if [ "$INSTALL_CAMERA" = "true" ]; then \
                 curl -sSL https://archive.raspberrypi.org/debian/raspberrypi.gpg.key | gpg --dearmor -o /usr/share/keyrings/raspberrypi-archive-keyring.gpg && \
                 echo "deb [signed-by=/usr/share/keyrings/raspberrypi-archive-keyring.gpg] http://archive.raspberrypi.org/debian/ bookworm main" > /etc/apt/sources.list.d/raspi.list; \
             fi

# Installera libcamera + Picamera2 + dependencies (valbart)
RUN if [ "$INSTALL_CAMERA" = "true" ]; then \
            apt-get update && apt-get install -y \
                python3-picamera2 \
                libcamera-dev \
                libcamera-apps \
                libatlas-base-dev && \
            apt-get clean; \
        else \
            echo "Skipping Raspberry Pi camera packages (INSTALL_CAMERA not true)"; \
        fi

# Applikation
WORKDIR /app
COPY . /app

# Installera Python-dependencies, hoppa över fel
RUN pip3 install --no-cache-dir -r requirements.txt || true

CMD ["python3", "ring.py"]
