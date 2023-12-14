class Runner
  def initialize(filename)
    @input = File.read(filename)
    @matrix = []
    @load = 0
  end

  def run
    parse_input

    # puts @matrix.inspect

    @matrix.each_with_index do |row, row_idx|
      row.each_with_index do |char, col_idx|
        slide_up(char, row_idx, col_idx)
      end
    end

    # @matrix.map {|m| puts m.join('')}

    @matrix.each_with_index do |row, row_idx|
      @load += get_load(row, row_idx)
    end

    puts @load
    @load
  end

  private

  def get_load(row, row_idx)
    matrix_height = @matrix.size

    (row.tally['O'] || 0) * (matrix_height - row_idx)
  end

  def parse_input
    @input.split("\n").each do |l|
      @matrix << l.split('')
    end
  end

  def slide_up(char, row_idx, col_idx)
    done = false

    if char == 'O'
      until done
        if row_idx - 1 >= 0 && @matrix[row_idx-1][col_idx] == '.'
          @matrix[row_idx][col_idx] = '.'
          @matrix[row_idx-1][col_idx] = 'O'
          row_idx = row_idx - 1
        else
          done = true
        end
      end
    end
  end
end

if Runner.new('test.txt').run == 136
  puts Runner.new('input.txt').run
end