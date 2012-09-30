#!/usr/bin/env ruby

require 'rubygems'
require 'mini_magick'

BASE_FOLDER = "Mine/Assets/"
TWO_X = "@2x"
SIZED = "-sized"

Dir.glob("#{BASE_FOLDER}*").each do |file|

next unless file.match(TWO_X)
next if file.match(SIZED) || file.match("Default")

puts file

image = MiniMagick::Image.open(file)
image.resize "50%"
image.write file.gsub(TWO_X,"")

end
