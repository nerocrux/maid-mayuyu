#!/usr/bin/env python
# -*- coding: utf-8 -*- 

import serial
import time
import os
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

ser = serial.Serial(
    port = '/dev/ttyUSB0',
    baudrate = 9600,
    parity = serial.PARITY_NONE,
    bytesize = serial.EIGHTBITS,
    stopbits = serial.STOPBITS_ONE,
    timeout = None,
    xonxoff = 0,
    rtscts = 0,
    )

while 1:
    rasp_output = ser.readline()
    if rasp_output.find('Temperature') != -1:
        command = "/home/pi/Work/wayterm/wayterm tweet " + '"' + "今おうちの室温だよ☆ " + rasp_output.strip() + '"'
        os.system(command)
        break
