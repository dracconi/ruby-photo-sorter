#!/usr/bin/env ruby
require 'exifr'
require 'pry'
require 'mimemagic'
# Files in dir
def files(directory)
    Dir["#{directory}/*"] if Dir.exist?(directory)
end
# Meta-data magic!
def meta_data(file)
    return unless MimeMagic.by_path(file).image?
    time = EXIFR::JPEG.new(file).date_time if MimeMagic.by_path(file).type == "image/jpeg"
    time = File.mtime(file) unless time
    time
end

# Welcome message
puts 'Hello user! Tell us your directory with photos.'
print '>>> '
dir = gets.chomp
files = files(dir)
# Sorting by time
timehash = {}
files.each do |file|
    timehash[file] = meta_data(file)
end
timehash.sort_by { |_key, value| value }
timehash.each { |key, value| puts "#{key} (#{value})" }
