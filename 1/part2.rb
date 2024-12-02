require 'byebug'

SAMPLE_FILE = 'sample.txt'
INPUT_FILE = 'input.txt'

data = nil
File.open(INPUT_FILE, 'r') do |f|
  data = f.readlines
end

list_1, list_2 = [[], []]

data.each do |data_point|
  a, b = data_point.split(' ')
  list_1 << a
  list_2 << b
end

solution = list_1.map.with_index do |l1_element, idx|
  count = list_2.find_all { |l2_element| l1_element == l2_element }.count
  count * l1_element.to_i
end.sum

puts "sum: #{solution}"
