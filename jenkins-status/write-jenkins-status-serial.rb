#!/usr/local/bin/ruby

require 'nokogiri'
require 'eat'
require 'yaml'
require 'serialport'

def fetch_jenkins
  source = YAML.load_file(".jenkins.yaml")['all']
  s = eat(source)
  xml = Nokogiri::XML.parse s

  response = []
  results = xml.xpath("/freeStyleProject/build/result")
  results.each do |status|
    response << encode_result(status.content)
  end
  return response.join('')
end

def send_to_arduino(to_be_send)
  port_str = '/dev/tty.usbserial-A6008hWB'
  baud_rate = 9600
  data_bits = 8
  stop_bits = 1
  parity = SerialPort::NONE
  sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
  puts to_be_send
  sp.write to_be_send
end

def encode_result(code)
  case code
  when 'SUCCESS'
    result = 1
  when 'FAILURE'
    result = 2
  when 'UNSTABLE'
    result = 3
  else
    result = 0
  end
  return result
end

def main
  if ARGV.length > 0 and ARGV[0] == 'RUN'
    send_to_arduino('r')
  else
    to_be_send = 'c' + fetch_jenkins()
    send_to_arduino(to_be_send[0...11])
  end
end

main
