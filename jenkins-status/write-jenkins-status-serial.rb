#!/usr/local/bin/ruby

require 'nokogiri'
require 'eat'
require 'yaml'
require 'serialport'

source = YAML.load_file(".jenkins.yaml")['source']
s = eat(source)
xml = Nokogiri::XML.parse s

status = xml.root.at_xpath("result").text

port_str = '/dev/tty.usbserial-A6008hWB'
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

sp.write status
