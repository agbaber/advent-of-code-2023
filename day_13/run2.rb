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
      mr = MatrixReflector.new(matrix)
      mr.run
      @num_left_cols += mr.num_left_cols
      @num_above_rows += mr.num_above_rows

      matrix.map {|m| puts m.join('')}
      puts "left cols: #{mr.num_left_cols}"
      puts "above rows: #{mr.num_above_rows}"
      puts "\n"
    end

    result = @num_left_cols + (@num_above_rows * 100)
    puts result
    result
  end

  private

  class MatrixReflector
    attr_reader :num_left_cols, :num_above_rows
    def initialize(matrix)
      @matrix = matrix
      @transposed_matrix = @matrix.transpose
      @num_left_cols = 0
      @num_above_rows = 0
    end

    def run
      check_cols
      check_rows
    end
    
    private

    def check_cols
      col_width = @matrix.first.size

      col_width.times.with_index do |i|
        half_col_width = col_width / 2.0
        mirror_point = i+0.5
        # if i == 9
        #   require 'pry';binding.pry
        # end
        if mirror_point >= half_col_width
          right_check = @transposed_matrix[i+1..-1]&.reverse || []
          a = right_check.flatten
          b = @transposed_matrix[i-right_check.size+1..i]&.flatten || []

          if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
            @num_left_cols += i+1
          end
        else
          left_check = @transposed_matrix[0..i]&.reverse || []
          a = left_check.flatten
          b = @transposed_matrix[i+1..i+left_check.size]&.flatten || []

          if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
            @num_left_cols += i+1
          end
        end
      end
    end

    def check_rows
      row_height = @matrix.size

      row_height.times.with_index do |i|
        half_row_height = row_height / 2.0
        mirror_point = i+0.5

        if mirror_point >= half_row_height
          below_check = @matrix[i+1..-1]&.reverse || []
          a = below_check.flatten
          b = @matrix[i-below_check.size+1..i]&.flatten || []

          if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
            @num_above_rows += i+1
          end
        else
          above_check = @matrix[0..i]&.reverse || []
          a = above_check.flatten
          b = @matrix[i+1..i+above_check.size]&.flatten || []

          if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
            @num_above_rows += i+1
          end
        end
      end
    end
  end
end

if Runner.new('test.txt').run == 400
  puts Runner.new('input.txt').run
end

# 32167 too low
# 37231 too low