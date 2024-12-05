require 'byebug'

# Battlehardened legacy jacket

SAMPLE_FILE = 'sample.txt'
INPUT_FILE = 'input.txt'

safe_reports = []
unsafe_reports = []
data = File.open(INPUT_FILE, 'r') do |f|
  f.readlines
end

def passes_difference?(a:, b:)
  if a > b
    (a - b) <= 3
  else
    (b - a) <= 3
  end
end

def is_report_safe?(elements:)
  previous_incrementing = nil
  previous_element = nil
  safe = true
  elements.each.with_index do |element, idx|
    current = element.to_i
    next if idx == 0

    previous_element = elements[idx - 1].to_i

    if previous_element == current
      safe = false
      break
    end

    if previous_incrementing.nil?
      previous_incrementing = current > previous_element
      unless passes_difference?(a: current, b: previous_element)
        safe = false
        break
      end
      next
    end

    # Check if still matching incrementing
    current_incrementing = current > previous_element

    if current_incrementing != previous_incrementing
      safe = false
      break
    end

    unless passes_difference?(a: current, b: previous_element)
      safe = false
      break
    end
  end

  safe
end

data.each do |line|
  elements = line.split(' ')
  safe = is_report_safe?(elements:)

  if safe
    safe_reports << elements
  else
    length = elements.count
    safe_permutation = nil
    (0..length).each do |i|
      new_permutation = elements.map(&:clone)
      new_permutation.delete_at(i)
      if is_report_safe?(elements: new_permutation)
        safe_permutation = new_permutation
        break
      end
    end
    if safe_permutation
      safe_reports << safe_permutation
      next
    end
    unsafe_reports << elements
  end
end

puts "Total safe: #{safe_reports.count}"
puts "Total unsafe: #{unsafe_reports.count}"
