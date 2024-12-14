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

puts stripped_lines

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
