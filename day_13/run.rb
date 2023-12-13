require 'matrix' 
class Runner
  def initialize(filename)
    @input = File.read(filename)
    @matrices = []
    @num_left_cols = 0
    @num_above_rows = 0
  end

  def run
    @input.split("\n\n").each do |set|
      lines = set.split("\n")
      @matrices << lines.map {|g|g.split('')}
    end

    @matrices.each do |matrix|
      col_matches = []
      row_matches = []
      found_inflection = nil

      matrix.each_with_index do |row, i|
        if row == matrix[i+1]
          # puts "found match: row #{i}"
          row_matches << i
        end
      end

      transposed_matrix = matrix.transpose
      transposed_matrix.each_with_index do |col, i|
        # require 'pry';binding.pry
        if col == transposed_matrix[i+1]
          # puts "found match: col: #{i}"
          col_matches << i
        end
      end

      col_matches.each do |i|
        col_width = matrix.first.size
        half_col_width = col_width / 2.0
        mirror_point = i+0.5

        if mirror_point >= half_col_width
          right_check = transposed_matrix[i+1..-1].reverse

          if right_check == transposed_matrix[i-right_check.size+1..i]
            @num_left_cols += i+1
            found_inflection = "col#{i}"
          end
        else
          left_check = transposed_matrix[0..i].reverse

          if left_check == transposed_matrix[i+1..i+left_check.size]
            @num_left_cols += i+1
            found_inflection = "col#{i}"
          end
        end
      end

      row_matches.each do |i|
        row_height = matrix.size
        half_row_height = row_height / 2.0
        mirror_point = i+0.5

        if mirror_point >= half_row_height
          below_check = matrix[i+1..-1].reverse

          if below_check == matrix[i-below_check.size+1..i]
            @num_above_rows += i+1
            found_inflection = "row#{i}"
          end
        else
          above_check = matrix[0..i].reverse

          if above_check == matrix[i+1..i+above_check.size]
            @num_above_rows += i+1
            found_inflection = "row#{i}"
          end
        end
      end

      matrix.map {|m| puts m.join('')}
      puts "col matches: #{col_matches.inspect}"
      puts "row matches: #{row_matches.inspect}"
      puts found_inflection
      puts "\n"
    end
    # require 'pry';binding.pry
    result = @num_left_cols + (@num_above_rows * 100)
    puts result
    result
  end

  private

end

if Runner.new('test.txt').run == 405
  Runner.new('input.txt').run
end

# 28096 too low