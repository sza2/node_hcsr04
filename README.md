# node_hcsr04
Distance measurement example for ESP8266/NodeMCU using HC-SR04 ultrasonic sensor

This example shows how to interface HC-SR04 ultrasonic sensor to ESP8266 with
NodeMCU firmware (2015-01-27 or later, since it uses floating point).

It uses 2 GPIOs, trig (GPIO2, IO index: 4) and echo (GPIO0, IO index: 3). 

The accuracy is usually ~1-2cm, Most probably the reason is not the sensor but
the interrupt and timing accuracy of the NodeMCU firmware, although it was not
tested.

The device class (hcsr04) has two user usable functions:

hcsr04.init() accepts two parameter, trig and echo pin index.
hcsr04.measure() initiate the measurement and returns the distance in meters (or
-1 if distance cannot be determined).

Bear in mind HC-SR04 nominal VDD is 5V. Based on my experience it stops working
under 3.5V, so the ESP8266 VDD may not be sufficient to power the ultrasonic
sensor.

Based on Rolox recommendation an average function was introduced. Theoretically
it makes the distance measurement more precise.
