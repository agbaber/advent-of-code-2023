require 'benchmark'

class Runner
  def initialize(filename)
    @input = File.read(filename)
    @instructions = []
    @mappings = {}
    @starting_points = []
    @ending_points = []
    @current_points = @starting_points
    @ended_on_z_at = {}
    @steps = 0
    @found_enough_data = false
  end

  def run
    @input.each_line do |line|
      match_data = line.match(/(?<point>\w{3}) = \((?<left>\w{3}), (?<right>\w{3})\)/)
      starting_match = line.match(/(?<point>\w{2}A) = \((?<left>\w{3}), (?<right>\w{3})\)/)
      ending_match = line.match(/(?<point>\w{2}Z) = \((?<left>\w{3}), (?<right>\w{3})\)/)

      if starting_match
        @starting_points << starting_match['point']
      end

      if ending_match
        @ending_points << ending_match['point']
      end

      if match_data
        @mappings[match_data['point']] = { left: match_data['left'], right: match_data['right']}
      else
        @instructions << line.chomp.split('')
      end
    end

    @instructions = @instructions.flatten.compact
    @instructions_size = @instructions.size
    @points_size = @current_points.size

    until @found_enough_data
      @current_points.each_with_index do |point, i|
        @current_direction = if @steps < @instructions_size
          @instructions[@steps]
        else
          @instructions[@steps % @instructions_size]
        end

        # require 'pry';binding.pry
        if @current_direction == 'L'
          @current_points[i] = @mappings[point][:left]
        else
          @current_points[i] = @mappings[point][:right]
        end

        if @ending_points.include?(@current_points[i])
          @ended_on_z_at[i] && @ended_on_z_at[i][:steps] ? @ended_on_z_at[i][:steps] << @steps : @ended_on_z_at[i]= {steps:[@steps]}
        end

      end
      @steps += 1
      # puts @current_points.inspect
      # puts @ended_on_z_at.inspect

      if @ended_on_z_at.size == @starting_points.size
        if @ended_on_z_at.all? {|k,v| v[:steps].size > 1}
          @ended_on_z_at.each_with_index do |h,i|
            @ended_on_z_at[i][:increment] = h[1][:steps][1] - h[1][:steps][0]
          end
        end
      end

      if @ended_on_z_at.any? && @ended_on_z_at.all? {|h| h[1][:increment]}
        @found_enough_data = true
      end
    end

    @ended_on_z_at.map {|h| h[1][:increment]}.reduce(1, :lcm)
  end

  private
end

if Runner.new('test3.txt').run == 6
  puts Benchmark.measure {
    puts Runner.new('input.txt').run
  }
end