class Runner
  def initialize(filename)
    @input = File.read(filename)

  end

  def run
    parse_input

    time = @race_data[:time]
    record_distance = @race_data[:distance]

    (1..time).to_a.each do |speed|
      if (time - speed) * speed > record_distance
        @race_data[:ways_to_beat] ? @race_data[:ways_to_beat] += 1 : @race_data[:ways_to_beat] = 1
        # could skip once we start losing
      end
    end

    @race_data[:ways_to_beat]
  end

  private

  def parse_input
    match_data = @input.match(/Time:(?<time>.+)$\nDistance:(?<distance>.+)/)

    @race_data = {
      time: match_data['time'].gsub(' ','').to_i,
      distance: match_data['distance'].gsub(' ','').to_i,
    }
  end
end

if Runner.new('test.txt').run == 71503
  puts Runner.new('input.txt').run
end
