class Runner
  STARTING_POINT = 'AAA'
  ENDING_POINT = 'ZZZ'

  def initialize(filename)
    @input = File.read(filename)
    @instructions = []

    @mappings = {}
    @current_point = STARTING_POINT
    @steps = 0
  end

  def run
    @input.each_line do |line|
      match_data = line.match(/(?<point>\D{3}) = \((?<left>\D{3}), (?<right>\D{3})\)/)

      if match_data
        @mappings[match_data['point']] = { left: match_data['left'], right: match_data['right']}
      else
        @instructions << line.chomp.split('')
      end
    end

    @instructions = @instructions.flatten.compact
    @instructions_size = @instructions.size

    until @current_point == ENDING_POINT
      @current_direction = if @steps < @instructions_size
        @instructions[@steps]
      else
        @instructions[@steps % @instructions_size]
      end

      if @current_direction == 'L'
        @current_point = @mappings[@current_point][:left]
      else
        @current_point = @mappings[@current_point][:right]
      end

      @steps += 1
    end

    @steps
  end

  private
end

if Runner.new('test.txt').run == 2 && Runner.new('test2.txt').run == 6
  puts Runner.new('input.txt').run
end