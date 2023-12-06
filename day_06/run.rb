class Runner
  def initialize(filename)
    @input = File.read(filename)

  end

  def run
    parse_input

    @race_data.each do |race|
      time = race[:time]
      record_distance = race[:distance]

      (1..time).to_a.each do |speed|
        if (time - speed) * speed > record_distance
          race[:ways_to_beat] ? race[:ways_to_beat] += 1 : race[:ways_to_beat] = 1
          # could skip once we start losing
        end
      end
    end

    @race_data.map {|r| r[:ways_to_beat]}.compact.inject(&:*)
  end

  private

  def parse_input
    match_data = @input.match(regexp)

    @race_data = [{
      time: match_data['first_race_time'].to_i,
      distance: match_data['first_race_distance'].to_i,
    },{
      time: match_data['second_race_time'].to_i,
      distance: match_data['second_race_distance'].to_i,
    },{
      time: match_data['third_race_time'].to_i,
      distance: match_data['third_race_distance'].to_i,
    },{
      time: match_data['fourth_race_time'].to_i,
      distance: match_data['fourth_race_distance'].to_i
    }].reject {|h| !h[:time]}
  end

  def regexp
    %r{
      Time:(\s+)
      (?<first_race_time>\d+)\s+
      (?<second_race_time>\d+)\s+
      (?<third_race_time>\d+)
      (\s+(?<fourth_race_time>\d+)|)\n

      Distance:\s+
      (?<first_race_distance>\d+)\s+
      (?<second_race_distance>\d+)\s+
      (?<third_race_distance>\d+)
      (\s+(?<fourth_race_distance>\d+)|)
    }x
  end
end

if Runner.new('test.txt').run == 288
  puts Runner.new('input.txt').run
end
