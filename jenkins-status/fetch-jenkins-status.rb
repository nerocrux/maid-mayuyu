#!/usr/local/bin/ruby

require 'nokogiri'
require 'eat'
require 'yaml'

source = YAML.load_file(".jenkins.yaml")['source']
s = eat(source)
xml = Nokogiri::XML.parse s

puts xml.root.at_xpath("result").text
