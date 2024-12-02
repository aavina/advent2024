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

puts "List 1: #{list_1}"
puts "List 2: #{list_2}"

list_1.sort!
list_2.sort!

puts "Sorted List 1: #{list_1}"
puts "Sorted List 2: #{list_2}"

distance_list = list_1.map.with_index do |l1_element, idx|
  l2_element = list_2[idx]
  distance = l1_element.to_i - l2_element.to_i

  if distance < 0
    distance = distance * -1
  end
  distance
end


puts "distance list: #{distance_list}"
solution = distance_list.sum

puts "sum: #{solution}"
