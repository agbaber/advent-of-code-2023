class Runner
  def initialize(filename)
    @input = File.read(filename)
    @mappings = []
    @seed_to_location_mapping = {}
    @lowest_location = nil
  end

  def run
    parse_input

    @seeds.each do |s|
      (s[0]..s[0] + s[1]).to_a.each do |seed|
        original_seed = seed.dup
        current_source = 'seed'

        until current_source == 'location'
          local_mappings = @mappings.find { |m| m[:source] == current_source}
          local_values = local_mappings[:values]
          found_mapping = local_values.find { |m| seed.between?(m[:source_start], m[:source_end])}

          if found_mapping
            seed = seed - found_mapping[:source_start] + found_mapping[:destination_start]
          end
          # require 'pry';binding.pry
          current_source = local_mappings[:destination]
          # puts "id: #{seed}, destination: #{current_source}"

        end


        if !@lowest_location || @lowest_location > seed
          @lowest_location = seed
        end
        # puts "\n"
      end
      # puts @seed_to_location_mapping
      # puts @seed_to_location_mapping.min_by { |k,v| v }.last
    end

    @lowest_location
  end

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