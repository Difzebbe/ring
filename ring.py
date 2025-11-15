"""
Filen ursprungliga innehåll kommenterad ut nedan.
Om du vill återskapa originalfunktionen, ta bort kommentaren.

Originalkod:

from picamera2 import Picamera2
from libcamera import Transform
import time
import numpy as np
import cv2

# Initiera Picamera2
picam2 = Picamera2()
picam2.start_preview(Preview.QT)
transform = Transform(hflip=1)
picam2.configure(picam2.create_video_configuration(transform=transform))
picam2.start()

# Funktion för att spela in video i 5 sekunder
def spela_in_video():
    video_file = "output.h264"
    print("Startar inspelning...")
    picam2.start_recording(video_file)
    time.sleep(5)  # Spela in i 5 sekunder
    picam2.stop_recording()
    print(f"Inspelning sparad som {video_file}")

# Huvudloop för rörelsedetektering
print("Systemet är igång. Väntar på rörelse...")

try:
    while True:
        frame = picam2.capture_array()  # Hämta en bildruta från kameran

        # Konvertera till gråskala för rörelsedetektering
        gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        blurred_frame = cv2.GaussianBlur(gray_frame, (21, 21), 0)

        # Initiera bakgrund om den inte finns
        if 'background' not in locals():
            background = blurred_frame
            continue

        # Beräkna skillnaden mellan bakgrund och aktuell bild
        frame_delta = cv2.absdiff(background, blurred_frame)
        thresh = cv2.threshold(frame_delta, 25, 255, cv2.THRESH_BINARY)[1]

        # Räkna antalet vita pixlar (indikerar rörelse)
        rörelse = cv2.countNonZero(thresh)
        if rörelse > 5000:  # Tröskelvärde för rörelse
            print("Rörelse upptäckt! Spelar in video...")
            spela_in_video()
            print("Väntar på ny rörelse...")

        # Uppdatera bakgrund (kan justeras för att vara dynamisk)
        background = blurred_frame

except KeyboardInterrupt:
    print("Avslutar programmet...")

finally:
    picam2.stop()

"""

import subprocess
import sys

def main():
    cmd = ["libcamera-still", "-o", "test.jpg"]
    try:
        print("Kör:", " ".join(cmd))
        subprocess.run(cmd, check=True)
        print("Bild sparad som test.jpg")
    except FileNotFoundError:
        print("Fel: 'libcamera-still' hittades inte. Kör detta på en enhet med libcamera installerad.")
        sys.exit(2)
    except subprocess.CalledProcessError as e:
        print("Kommandot misslyckades med returkod:", e.returncode)
        sys.exit(e.returncode)

if __name__ == "__main__":
    main()
