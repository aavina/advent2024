require 'byebug'

SAMPLE_FILE = 'sample.txt'
INPUT_FILE = 'input.txt'

data = File.open(INPUT_FILE, 'r') do |f|
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
    hits = 0

    self.map.each.with_index do |row, ridx|
      row.each.with_index do |element, cidx|
        if find_hit(y: cidx, x: ridx) == true
          hits += 1
        end
      end
    end
    hits
  end

  private

  def find_hit(x:, y:)
    hits = 0
    return 0 unless get_char(x:, y:) == 'A'
    return 0 unless (x + 1 < self.map[0].size) &&
      (x - 1 >= 0) && (y + 1 < self.map.size) && (y - 1 >= 0)

    forward_slash_found = false
    back_slash_found = false
    if get_char(x: x - 1, y: y - 1) == 'M' &&
      get_char(x: x + 1, y: y + 1) == 'S'
      forward_slash_found = true
    end

    if get_char(x: x - 1, y: y - 1) == 'S' &&
      get_char(x: x + 1, y: y + 1) == 'M'
      forward_slash_found = true
    end

    if get_char(x: x - 1, y: y + 1) == 'S' &&
      get_char(x: x + 1, y: y - 1) == 'M'
      back_slash_found = true
    end

    if get_char(x: x - 1, y: y + 1) == 'M' &&
      get_char(x: x + 1, y: y - 1) == 'S'
      back_slash_found = true
    end

    forward_slash_found && back_slash_found
  end

  def get_char(x:, y:)
    self.map[y][x]
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
