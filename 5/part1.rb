require 'byebug'

SAMPLE_FILE = 'sample.txt'
INPUT_FILE = 'input.txt'

ordering_lines = []
update_lines = []
seen_break = false
data = File.open(SAMPLE_FILE, 'r') do |f|
  f.readlines
end

data.each do |line|
  if line == "\n"
    seen_break = true
    next
  end
  ordering_lines << line.strip unless seen_break
  update_lines << line.strip if seen_break
end

puts "Ordering: #{ordering_lines}"
puts "Update: #{update_lines}"

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
        hits += find_hits(y: cidx, x: ridx)
      end
    end
    hits
  end

  private

  def find_hits(x:, y:)
    hits = 0
    return 0 unless get_char(x:, y:) == 'X'

    if (x + 3) < self.map[0].size 
      if get_char(x: x+1, y:) == 'M' &&
        get_char(x: x+2, y:) == 'A' &&
        get_char(x: x+3, y:) == 'S'
        hits += 1
      end
    end

    if (x - 3) >= 0
      if get_char(x: x-1, y:) == 'M' &&
        get_char(x: x-2, y:) == 'A' &&
        get_char(x: x-3, y:) == 'S'
        hits += 1
      end
    end

    if (y + 3) < self.map.size
      if get_char(x: x, y: y + 1) == 'M' &&
        get_char(x: x, y: y + 2) == 'A' &&
        get_char(x: x, y: y + 3) == 'S'
        hits += 1
      end
    end

    if (y - 3) >= 0
      if get_char(x: x, y: y - 1) == 'M' &&
        get_char(x: x, y: y - 2) == 'A' &&
        get_char(x: x, y: y - 3) == 'S'
        hits += 1
      end
    end

    if (x - 3) >= 0 && (y - 3) >= 0
      if get_char(x: x - 1, y: y - 1) == 'M' &&
        get_char(x: x - 2, y: y - 2) == 'A' &&
        get_char(x: x - 3, y: y - 3) == 'S'
        hits += 1
      end
    end

    if (x - 3) >= 0 && (y + 3) < self.map.size
      if get_char(x: x - 1, y: y + 1) == 'M' &&
        get_char(x: x - 2, y: y + 2) == 'A' &&
        get_char(x: x - 3, y: y + 3) == 'S'
        hits += 1
      end
    end

    if (x + 3) < self.map[0].size && (y - 3) >= 0
      if get_char(x: x + 1, y: y - 1) == 'M' &&
        get_char(x: x + 2, y: y - 2) == 'A' &&
        get_char(x: x + 3, y: y - 3) == 'S'
        hits += 1
      end
    end

    if (x + 3) < self.map[0].size && (y + 3) < self.map.size
      if get_char(x: x + 1, y: y + 1) == 'M' &&
        get_char(x: x + 2, y: y + 2) == 'A' &&
        get_char(x: x + 3, y: y + 3) == 'S'
        hits += 1
      end
    end

    hits
  end

  def get_char(x:, y:)
    self.map[y][x]
  end
end

# ceres_map = CeresMap.new(lines: stripped_lines)

# puts ceres_map.solve

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
