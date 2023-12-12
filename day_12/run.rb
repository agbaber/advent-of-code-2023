class Runner
  def initialize(filename)
    @input = File.read(filename)
    @lines = []
  end

  def run
    @input.each_line do |line|
      springs, records = line.split(' ')
      hash_records = []
      records.split(',').map(&:to_i).each do |r|
        hash_records << {r => {permutations: []}}
      end

      @lines << {
        springs: springs.split(''),
        records: hash_records,
        permutations_count: 0 
      }
    end

    # puts @lines.inspect

    @lines.each do |line|
      line[:records].each_with_index do |record, i|
        record_num = record.keys.first
        # require 'pry';binding.pry
        output = []

        if i == 0
          record_num.times do
            output << '#'
          end

          output << '.'
          record[record_num][:permutations] << {values: output, valid_at: [], invalid_at: [], start_at: nil}
        elsif i == line[:records].size - 1
          output = ['.']
          record_num.times do
            output << '#'
          end
          record[record_num][:permutations] << {values: output, valid_at: [], invalid_at: [], start_at: nil}
        end

        output = ['.']
        record_num.times do
          output << '#'
        end
        output << '.'
        
        # require 'pry';binding.pry

        record[record_num][:permutations] << {values: output, valid_at: [], invalid_at: [], start_at: nil}
      end
    end

    @lines.each do |line|
      line[:records].each do |record|
        record.each_with_index do |element, i|
          # puts "#{num} - #{permutations[:permutations].inspect}"
          element[1][:permutations].each_with_index do |permutation, p_idx|
            permutation[:start_at] = p_idx
            invalid_after_valid = nil
            values = permutation[:values]
            i = 0

            until invalid_after_valid || i >= line[:springs].size
              original_line_chars = line[:springs][i..values.size - 1]
              # require 'pry';binding.pry
              if original_line_chars.size == values.size
                values.size.times do |idx|
                  if original_line_chars[idx] == '#' && values[idx] == '.'
                    if permutation[:valid_at].any?
                      invalid_after_valid = true
                    end

                    permutation[:invalid_at] << i
                  end
                end

                unless permutation[:invalid_at].include?(i)
                  permutation[:valid_at] << i
                end
                puts permutation
              end

              i+=1
            end
          end
        end
      end
    end


    puts @lines.inspect

      # current_record_idx = 0
      # current_record = line[:records][current_record_idx]
      # line[:springs].each_with_index do |char, i|
      #   require 'pry';binding.pry
      #   if char == '?'
      #     if line[:springs][i+1..i+current_record].select{|c| c == '#'}.size + 1 > current_record
      #     end
      #   end
      # end

    #   first_record = line[:records].first
    #   remaining_records = line[:records][1..-1]
    #   num_remaining = remaining_records.inject(&:+) + remaining_records.size
    #   permutation_space = line[:springs][0..-num_remaining-1]
    #   broken_indexes = permutation_space.each_index.select { |i| permutation_space[i] == '#' }

    #   require 'pry';binding.pry
    #   if permutation_space.size == first_record
    #     permutation_space[]
    #   elsif permutation_space.select {|p| p == '#'}.any?
    #     if permutation_space.select {|p| p == '#'}.size == first_record
    #       current_char = nil
    #       until current_char == '#'
    #         line[:records].each do |r|
    #           r = '.'
    #         end
    #       end
    #     else

    #     end
    #   end
    # end
    # end
  end

  private

  def get_valid_at_idx()
end

if Runner.new('test.txt').run == 21
  puts Runner.new('input.txt').run 
end