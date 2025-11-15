# Use a Raspberry Pi OS-compatible base image
FROM balenalib/rpi-raspbian:latest

# Set the working directory in the container
WORKDIR /app

# Install system dependencies required for picamera2
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-picamera2 \
    libcamera-dev \
    libatlas-base-dev \
    && apt-get clean

# Copy the current directory contents into the container
COPY . /app

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt || true

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define the command to run the application
CMD ["python3", "ring.py"]