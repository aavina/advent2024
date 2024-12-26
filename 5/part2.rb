require 'byebug'

SAMPLE_FILE = 'sample.txt'
INPUT_FILE = 'input.txt'

ordering_rules = {}
update_lines = []
seen_break = false
data = File.open(INPUT_FILE, 'r') do |f|
  f.readlines
end

data.each do |line|
  if line == "\n"
    seen_break = true
    next
  end
  unless seen_break
    prefix, suffix = line.strip.split('|')
    prefix = prefix.to_i
    suffix = suffix.to_i
    ordering_rules[prefix] ||={ before: Set.new, after: Set.new }
    ordering_rules[prefix][:before] << suffix
    ordering_rules[suffix] ||={ before: Set.new, after: Set.new }
    ordering_rules[suffix][:after] << prefix
    next
  else
    update_lines << line.strip
  end
end

def test_line(ordering_rules:, numbers:)
  numbers.each.with_index do |num, idx|
    # TODO: Test left
    (0...idx-1).reverse_each do |ridx|
      other = numbers[ridx]
      violating_nums = ordering_rules[num][:before]
      return true if violating_nums.include?(other)
    end
    # TODO: Test right
    (idx+1..numbers.size-1).each do |fidx|
      other = numbers[fidx]
      violating_nums = ordering_rules[num][:after]
      return true if violating_nums.include?(other)
    end
  end
  false
end

accepted = update_lines.map do |line|
  result = nil
  numbers = line.split(',').map { |num| num.to_i }
  passes = test_line(ordering_rules:, numbers:)
  result = numbers if passes

  result
end.select! { |nums| !nums.nil? }

corrected = accepted.map do |line|
  correcting = true
  new_line = line.map(&:clone)
  while(correcting)
    reset = false
    new_line.each.with_index do |num, idx|
      current_num = num
      # Left
      (0...idx-1).reverse_each do |ridx|
        other = new_line[ridx]
        violating_nums = ordering_rules[num][:before]
        if violating_nums.include?(other)
          new_line[ridx] = current_num
          new_line[idx] = other
          current_num = other
          reset = true
        end
      end
      # Right
      (idx+1..new_line.size-1).each do |fidx|
        other = new_line[fidx]
        violating_nums = ordering_rules[num][:after]
        if violating_nums.include?(other)
          new_line[fidx] = current_num
          new_line[idx] = other
          current_num = other
          reset = true
        end
      end
    end
    correcting = reset
  end
  new_line
end

sum = 0

answer = corrected.map do |line|
  middle = line.size/2
  line[middle]
end.sum

puts "Answer: #{answer}"
