require 'byebug'

SAMPLE_FILE = 'sample.txt'
INPUT_FILE = 'input.txt'

data = File.open(SAMPLE_FILE, 'r') do |f|
  f.readlines
end

stripped_lines = []
data.each do |line|
  stripped_lines << line.strip
end

puts stripped_lines
