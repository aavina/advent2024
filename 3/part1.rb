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

# :finding_start
# :finding_numbers
state = :finding_start

track_chars = 'mul('
current_char_idx = 0
current_number_str = ''
current_product = nil
total = 0
continuous_data.chars.each do |char|
  current_char = track_chars[current_char_idx]

  if state == :finding_numbers
    if char == ',' or char ==')'
      # done, create the number
      current_number = current_number_str.to_i
      if current_product.nil?
        current_product = current_number
      else
        puts "current_number: #{current_number}"
        current_product *= current_number
        total += current_product
        current_product = nil
        state = :finding_start
      end
      current_char_idx = 0
      current_number_str = ''
    else
      begin
        int_char = char.to_i
        current_number_str += char
      rescue ArgumentError
        state = :finding_start
        current_char_idx = 0
        current_number_str = ''
      end
    end
    next
  end

  if char != current_char
    current_char_idx = 0
    current_number_str = ''
    state = :finding_start
  elsif char == '('
    state = :finding_numbers
    current_char_idx = 0
  else
    current_char_idx += 1
  end
end

puts "Total: #{total}"
