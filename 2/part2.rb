require 'byebug'

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

    safe = false && break if previous_element == current

    if previous_incrementing.nil?
      previous_incrementing = current > previous_element
      safe = false && break unless passes_difference?(a: current, b: previous_element)
      next
    end

    # Check if still matching incrementing
    current_incrementing = current > previous_element

    safe = false && break if current_incrementing != previous_incrementing
    safe = false && break unless passes_difference?(a: current, b: previous_element)
  end

  safe
end

data.each do |line|
  elements = line.split(' ')
  safe = is_report_safe?(elements:)

  safe_reports << elements && next if safe

  length = elements.count
  safe_permutation = nil
  (0..length).each do |i|
    new_permutation = elements.map(&:clone)
    new_permutation.delete_at(i)
    (safe_permutation = new_permutation) && break if is_report_safe?(elements: new_permutation)
  end
  
  safe_reports << safe_permutation && next if safe_permutation
  unsafe_reports << elements
end

puts "Total safe: #{safe_reports.count}"
puts "Total unsafe: #{unsafe_reports.count}"
