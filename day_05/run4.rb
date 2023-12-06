class Runner
  def initialize(filename)
    @input = File.read(filename)
    @mappings = []
    @seed_to_location_mapping = {}
    @lowest_location = nil
  end

  def run
    parse_input

    location = 0

    until @lowest_location
      location += 1

      if location % 10000 == 0
        puts location
      end

      test_location = location.dup
      current_source = 'location'

      until current_source == 'seed'
        local_mappings = @mappings.find { |m| m[:destination] == current_source}
        local_values = local_mappings[:values]
        found_mapping = local_values.find { |m| test_location.between?(m[:destination_start], m[:destination_end])}

        if found_mapping
          test_location = found_mapping[:source_start] + test_location - found_mapping[:destination_start]
        end

        current_source = local_mappings[:source]
        found_mapping = nil
      end

      @seeds.each do |k,v|
        if test_location.between?(k, k + v)
          @lowest_location = location
        end
      end
    end

    puts "ll: #{@lowest_location}"
    @lowest_location
  end

  # 2254687 too high
  # 2254686

  private

  def parse_input
    @input.split("\n\n").each do |mapping|
      values = mapping.split(':')

      if values.first == 'seeds'
        @seeds = values.last.split(' ').map(&:to_i).each_slice(2).to_a
      else
        matches = values.first.match(/(?<source>\w+)-to-(?<destination>\w+) map/)
        mappings = values.last.split("\n").reject(&:empty?).map { |a| a.split(' ').map(&:to_i) }
        current_mappings = []

        mappings.each do |destination_start, source_start, range|
          current_mappings << {
            destination_start: destination_start,
            destination_end: destination_start + range,
            source_start: source_start,
            source_end: source_start + range,
            range: range
          }
        end

        @mappings << {
          source: matches['source'],
          destination: matches['destination'],
          values: current_mappings
        }
      end
    end
  end
end

if Runner.new('test.txt').run == 46
  puts Runner.new('input.txt').run
end