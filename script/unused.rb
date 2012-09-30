#!/usr/bin/env ruby

BASE_FOLDER = "Mine"
ASSETS_FOLDER = File.join BASE_FOLDER,"Assets/"
TWO_X = "@2x"



Dir.glob("#{ASSETS_FOLDER}*").each do |file|
  next if file.match(TWO_X) || file.match("Default")

  results = `grep -ir "#{File.basename(file)}" #{BASE_FOLDER} | wc -l`
  
  puts file if results.to_i == 0
end
