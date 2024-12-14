require 'byebug'

SAMPLE_FILE = 'sample.txt'
SAMPLE_FILE_2 = 'sample2.txt'
INPUT_FILE = 'input.txt'

class Multiplier
  TRACK_CHARS = 'ul('
  DO_SHARED = 'o'
  DO_CHARS = ')'
  DONT_CHARS = "'t()"

  def initialize(data:)
    @data = data
    @total = 0
    @tracker = nil
    @enabled = true
    reset
  end

  def determine_product
    @data.chars.each do |char|
      case @state
      when :finding_start
        find_start(char:)
      when :between_dos
        if char == current_track_char
          if char == @tracker[-1]
            @state = :determining_do
            @tracker_idx = 0
            next
          end
          @tracker_idx += 1
        else
          reset
        end
      when :determining_do
        if char == '('
          @state = :finding_start
          @tracker = DO_CHARS
          @tracker_idx = 0
        elsif char == 'n'
          @state = :finding_start
          @tracker = DONT_CHARS
          @tracker_idx = 0
        else
          reset
        end
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
    @tracker[@tracker_idx]
  end

  def find_start(char:)
    if @tracker == nil
      if char == 'd'
        @state = :between_dos
        @tracker_idx = 0
        @tracker = DO_SHARED
      elsif char == 'm'
        @tracker = TRACK_CHARS
      end
      return
    end

    case @tracker
    when TRACK_CHARS
      if char == current_track_char
        @state = :finding_first_num if char == '('
      else
        reset
        return
      end
    when DO_CHARS, DONT_CHARS
      if char == current_track_char
        if char == ')'
          @enabled = (@tracker == DO_CHARS)
          reset
          return
        end
      else
        reset
        return
      end
    end
    @tracker_idx += 1
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
      @total += (@first_number.to_i * @second_number.to_i) if @enabled
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
    @tracker = nil
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
