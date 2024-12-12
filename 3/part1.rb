require 'byebug'

SAMPLE_FILE = 'sample.txt'
INPUT_FILE = 'input.txt'

class Multiplier
  TRACK_CHARS = 'mul('

  def initialize(data:)
    @data = data
    @total = 0
    reset
  end

  def determine_product
    @data.chars.each do |char|
      case @state
      when :finding_start
        find_start(char:)
      when :finding_first_num
        find_first_number(char:)
      when :finding_second_num
        find_second_number(char:)
      end
    end

    @total
  end

  private

  def current_track_char
    TRACK_CHARS[@tracker_idx]
  end

  def find_start(char:)
    if char == current_track_char
      @state = :finding_first_num if char == '('
      @tracker_idx += 1
    else
      reset
    end
  end

  def find_first_number(char:)
    if char == ','
      if @first_number == ''
        reset
        return
      end
      @state = :finding_second_num
      return
    end

    raise ArgumentError unless ('0'..'9').include?(char)

    @first_number += char
  rescue ArgumentError
    reset
  end

  def find_second_number(char:)
    if char == ')'
      if @second_number == ''
        reset
        return
      end
      @total += (@first_number.to_i * @second_number.to_i)
      reset
      return
    end

    raise ArgumentError unless ('0'..'9').include?(char)

    @second_number += char
  rescue ArgumentError
    reset
  end

  def reset
    @tracker_idx = 0
    @state = :finding_start
    @first_number = ''
    @second_number = ''
  end
end

data = File.open(INPUT_FILE, 'r') do |f|
  f.readlines
end

continuous_data = ''
data.each do |line|
  continuous_data += line.strip
end

multiplier = Multiplier.new(data: continuous_data)
puts multiplier.determine_product
