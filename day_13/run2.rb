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

    @matrices.each_with_index do |matrix, m_idx|
      col_matches = {}
      row_matches = {}

      found_inflections = nil

      matrix.each_with_index do |row, i|
        # puts row.join('')
        # sleep 0.5
        # require 'pry';binding.pry
        if row == matrix[i+1]
          # puts "found match: row #{i}"
          row_matches[i] = false
        else
          a = row
          b = matrix[i+1] || []

          if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
            @matrices[m_idx][i+1] = a
            matrix[i+1] = a
            row_matches[i] = true
          end
        end
      end
      
      transposed_matrix = matrix.transpose

      transposed_matrix.each_with_index do |col, i|
        if col == transposed_matrix[i+1]
          col_matches[i] = false
        else
          a = col
          b = transposed_matrix[i+1] || []

          if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1
            @matrices[m_idx].each_with_index do |row, i|
              row[i+1] = col[i]
            end

            matrix.each_with_index do |row, i|
              row[i+1] = col[i]
            end

            col_matches[i] = true
          end
        end
      end

      found_inflections = []

      already_desmudged = false

      col_matches.select {|k,v| v}.each do |i,_desmudged|
        require 'pry';binding.pry
        col_width = matrix.first.size
        half_col_width = col_width / 2.0
        mirror_point = i+0.5

        if mirror_point >= half_col_width
          right_check = transposed_matrix[i+1..-1].reverse

          if right_check == transposed_matrix[i-right_check.size+1..i]
            @num_left_cols += i+1
            found_inflections << "col#{i}"
          end
        else
          left_check = transposed_matrix[0..i].reverse

          if left_check == transposed_matrix[i+1..i+left_check.size]
            @num_left_cols += i+1
            found_inflections << "col#{i}"
          end
        end
      end

      unless already_desmudged
        col_matches.select {|k,v| !v}.each do |i,_desmudged|

          col_width = matrix.first.size
          half_col_width = col_width / 2.0
          mirror_point = i+0.5

          if mirror_point >= half_col_width
            right_check = transposed_matrix[i+1..-1].reverse

            a = right_check.flatten
            b = transposed_matrix[i-right_check.size+1..i].flatten

            if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
              @num_left_cols += i+1
              found_inflections << "col#{i}"
            end
          else
            left_check = transposed_matrix[0..i].reverse
            a = left_check.flatten
            b = transposed_matrix[i+1..i+left_check.size].flatten

            if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
              @num_left_cols += i+1
              found_inflections << "col#{i}"
            end
          end
        end
      end

      row_matches.select {|k,v| v}.each do |i,_desmudged|
        row_height = matrix.size
        half_row_height = row_height / 2.0
        mirror_point = i+0.5

        if mirror_point >= half_row_height
          below_check = matrix[i+1..-1].reverse

          if below_check == matrix[i-below_check.size+1..i]
            @num_above_rows += i+1
            found_inflections << "row#{i}"
          end
        else
          above_check = matrix[0..i].reverse

          if above_check == matrix[i+1..i+above_check.size]
            @num_above_rows += i+1
            found_inflections << "row#{i}"
            already_desmudged = true
          end
        end
      end

      unless already_desmudged
        row_matches.select {|k,v| !v}.each do |i,_desmudged|
          row_height = matrix.size
          half_row_height = row_height / 2.0
          mirror_point = i+0.5

          if mirror_point >= half_row_height
            below_check = matrix[i+1..-1].reverse

            a = below_check.flatten
            b = matrix[i-below_check.size+1..i].flatten
            # require 'pry';binding.pry
            if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
              @num_above_rows += i+1
              found_inflections << "row#{i}"
            end
          else
            above_check = matrix[0..i].reverse

            a = above_check.flatten
            b = matrix[i+1..i+above_check.size].flatten
            # require 'pry';binding.pry
            if a.size == b.size && a.map.with_index {|a,i| a == b[i]}.tally[false] == 1 
              @num_above_rows += i+1
              found_inflections << "row#{i}"
            end
          end
        end
      end

      matrix.map {|m| puts m.join('')}
      puts "col matches: #{col_matches.inspect}"
      puts "row matches: #{row_matches.inspect}"
      puts "found_inflections: #{found_inflections}"
      puts "\n"
    end
    # require 'pry';binding.pry
    result = @num_left_cols + (@num_above_rows * 100)
    puts result
    result
  end

  private

end

# if Runner.new('test.txt').run == 400
  puts Runner.new('input.txt').run
# end

# 32167 too low