require 'byebug'

SAMPLE_FILE = 'sample.txt'
INPUT_FILE = 'input.txt'

data = File.open(SAMPLE_FILE, 'r') do |f|
  f.readlines
end

continuous_data = ''
data.each do |line|
  continuous_data += line.strip
end

puts continuous_data
