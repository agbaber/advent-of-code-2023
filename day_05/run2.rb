class Runner
  def initialize(filename)
    @input = File.read(filename)
    @mappings = []
    @seed_to_location_mapping = {}
    @seeds = []
  end

  def run
    parse_input

    # location_mappings = @mappings.find { |m| m[:destination] == 'location'}
    # require 'pry';binding.pry
    # until @seed_to_location_mapping.min_by { |k,v| v }&.last
    #   location_mappings[:values].sort_by { |m| m[:destination_start]}.reverse.each do |source_data|

    #     source = location_mappings[:source]

    #     until source == 'seed'
    #       location_mappings = @mappings.find { |m| m[:destination] == source}
    #       source_start = source_data[:source_start]
    #       source_end = source_data[:source_end]

    #       @matching_values = location_mappings[:values].select do |m|
    #         source_start.between?(m[:destination_start], m[:destination_end]) ||
    #           source_end.between?(m[:destination_start], m[:destination_end])
    #       end

    #       source = location_mappings[:source]
    #     end

        # @seeds.each do |s|
          # puts s.inspect
          # if s[0] >= @matching_values.first[:source_start] && s[0] <= @matching_values.first[:source_end] &&
          #     s[0] + s[1] <= @matching_values.first[:source_end]
            # (s[0]..s[0] + s[1]).to_a.each_slice(10_000).map(&:first).each do |seed|
            (2405196863..2406693242).to_a.each do |seed|
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

              @seed_to_location_mapping[original_seed] = seed
              # puts "\n"
            end
          # end
          # puts @seed_to_location_mapping
          puts @seed_to_location_mapping.min_by { |k,v| v }&.last
# puts @seed_to_location_mapping.select {|k,v| v == 2258308}
          result = @seed_to_location_mapping.min_by { |k,v| v }&.last
          puts @seed_to_location_mapping.select {|k,v| v == result}
          result
        # end
      # end
    # end


    require 'pry';binding.pry

    @seed_to_location_mapping.min_by { |k,v| v }&.last
  end

  # 2258308 too high
  # 2254687 too high

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

# if Runner.new('test.txt').run == 46
  puts Runner.new('input.txt').run
# end