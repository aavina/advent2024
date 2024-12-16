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

class CeresMap
  attr_accessor :map

  def initialize(lines:)
    cols = lines.first.size
    rows = lines.size
    self.map = Array.new(rows) { Array.new(cols) }
    lines.each.with_index do |line, idx|
      self.map[idx] = line.chars
    end
  end

  def solve
    times_found = 0

    self.map.each.with_index do |row, ridx|
      row.each.with_index do |element, cidx|
        puts element
      end
    end
    times_found
  end
end

ceres_map = CeresMap.new(lines: stripped_lines)

puts ceres_map.solve

# TODO: Everytime a `X` is found, need to check:
# 1. right-to-left
# 2. left-to-right
# 3. up-to-down
# 4. down-to-up
# 5. diagnoal: down right
# 6. diagonal: down left
# 7. diagonal: up left
# 8. diagonal: up right
# Note that the "base" is the current position so no need
# for starting to check in the middle of "XMAS"
