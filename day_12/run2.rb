class Runner
  def initialize(filename)
    @input = File.read(filename)
    @lines = []
  end

  def run
    @input.each_line do |line|
      springs, records = line.split(' ')
      mapped_records = records.split(',').map(&:to_i)
      # require 'pry';binding.pry

      @lines << {
        springs: springs.split('') * 5,
        records: mapped_records * 5,
        valid_combinations: 0
      }
    end


    @lines.each do |line|
      unknown_idxs = indices(line[:springs], '?')

      combos = ['.','#'].repeated_permutation(unknown_idxs.size).to_a

      combos.each_with_index do |combo|
        copied_line = line[:springs].dup

        unknown_idxs.each_with_index do |idx, i|
          copied_line[idx] = combo[i]
        end

        if valid?(copied_line, line[:records])
          line[:valid_combinations] += 1
        end
      end
    end

    # puts @lines.inspect

    @lines.map {|l| l[:valid_combinations]}.inject(&:+)
  end

  private

  def indices(array, symbol)
    array.each_index.select { |index| array[index] == symbol }
  end

  def valid?(line, records)
    if line.tally['#'] == records.inject(&:+) &&
      line.join('').split('.').reject {|e| e.empty?}.size == records.size

      real_records = []
      count = 0

      line.each_with_index do |l, i|
        if l == '#'
          count += 1

          if line[i+1] == '.' || line[i+1].nil?
            real_records << count
            count = 0
          end
        end
      end
      # puts real_records.inspect
      # puts line.inspect
      if real_records == records
        # puts line.inspect
        # require 'pry';binding.pry
        true
      end
    end
  end
end

if Runner.new('test.txt').run == 525152
  puts "Success. Doing it for real..."
  puts Runner.new('input.txt').run 
end