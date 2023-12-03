require 'matrix'

class Runner
  def initialize(filename)
    @input = File.read(filename)
    @input_lines = @input.split("\n")
    @numbers = []
    @symbols = []
    @covered_coords = []
    @finding_num = false
    @id = 1
    @touching_nums = []
  end

  def run
    @input.each_line.with_index do |line, line_number|
      line.strip.split('').each.with_index do |character, col_number|
        if character =~ /\d/ && !@covered_coords.include?([line_number, col_number])
          @finding_num = true
          @covered_coords << [line_number, col_number]
          @current_num = {
            id: @id,
            num_string: character,
            start_col: col_number,
            end_col: col_number,
            row: line_number
          }
          idx = 1

          until @finding_num == false
            # require 'pry';binding.pry
            if @input_lines[line_number][col_number + idx] && @input_lines[line_number][col_number + idx] =~ /\d/
              @current_num[:num_string] += @input_lines[line_number][col_number + idx]
              @current_num[:end_col] = col_number + idx
              @covered_coords << [line_number, col_number + idx]
            else
              @finding_num = false
              @id += 1
            end
            idx += 1
          end
          # puts "adding #{@current_num.inspect}"

          @numbers << @current_num
        end

        unless character =~ /[A-Za-z0-9.]/
          symbol = {
            coords: [line_number, col_number]
          }
          @symbols << symbol
        end
      end
    end
    
    @symbols.each do |symbol|
      coords = symbol[:coords]
      touching_rows = [coords.first, coords.first - 1, coords.first + 1]
      touching_cols = [coords.last, coords.last - 1, coords.last + 1]
      touching_nums = @numbers.select { |num| touching_rows.include?(num[:row]) && ((num[:start_col]..num[:end_col]).to_a & touching_cols).any?}

      if touching_nums.size == 2
        @touching_nums << touching_nums.map {|tn| tn[:num_string].to_i }.inject(&:*)
      end
    end

    # puts @touching_nums.inspect
    @touching_nums.flatten.inject(&:+)
  end

  private

end

if Runner.new('test.txt').run == 467835
  puts Runner.new('input.txt').run
end

