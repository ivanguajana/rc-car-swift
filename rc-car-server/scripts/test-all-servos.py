import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

GPIO.setup(13, GPIO.OUT)
GPIO.setup(18, GPIO.OUT)

p1 = GPIO.PWM(13, 50)
p2 = GPIO.PWM(18, 50)

p1.start(7.0)
p2.start(7.0)

try:
    while True:
        for duty in [5.0, 5.5, 6.0, 7.0, 7.5, 8.0]:
            p1.ChangeDutyCycle(duty)
            p2.ChangeDutyCycle(duty)
            time.sleep(1)

except KeyboardInterrupt:
    p1.stop()
    p2.stop()
    GPIO.cleanup()
