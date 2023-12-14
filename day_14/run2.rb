class Runner
  def initialize(filename)
    @input = File.read(filename)
    @matrix = []
    @load = 0
    @loads = {}
  end

  def run
    parse_input

    # puts @matrix.inspect

    500.times.with_index do |i|
      @matrix.each_with_index do |row, row_idx|
        row.each_with_index do |char, col_idx|
          slide(:up, char, row_idx, col_idx)
        end
      end

      # require 'pry';binding.pry

      @matrix.each_with_index do |row, row_idx|
        row.each_with_index do |char, col_idx|
          slide(:left, char, row_idx, col_idx)
        end
      end

      @matrix.reverse.each_with_index do |row, row_idx|
        row.each_with_index do |char, col_idx|
          slide(:down, char, row_idx, col_idx)
        end
      end

      @matrix.each_with_index do |row, row_idx|
        row.reverse.each_with_index do |char, col_idx|
          slide(:right, char, row_idx, col_idx)
        end
      end

      load_val = 0
      @matrix.each_with_index do |row, row_idx|
        load_val += get_load(row, row_idx)
      end
      @loads[i] = load_val


      # puts @loads.inspect
      # @matrix.map {|m| puts m.join('')}
    end


    # @matrix.map {|m| puts m.join('')}

    # @matrix.each_with_index do |row, row_idx|
    #   @load += get_load(row, row_idx)
    # end
    require 'pry';binding.pry
    @loads[138 + (1000000000 % 14) + 1]

 # 12 138=>104667,
 # 13 139=>104663,
 # 0 140=>104650,
 # 1 141=>104649,
 # 2 142=>104640,
 # 3 143=>104651,
 # 4 144=>104662,
 # 5 145=>104671,
 # 6 146=>104659,
 # 7 147=>104654,
 # 8 148=>104645,
 # 9 149=>104644,
 # 10 150=>104647,
 # 11 151=>104666,

 # 152=>104667,
 # 153=>104663,
 # 154=>104650,
 # 155=>104649,
 # 156=>104640,
 # 157=>104651,
 # 158=>104662,
 # 159=>104671,
 # 160=>104659,
 # 161=>104654,
 # 162=>104645,
 # 163=>104644,
 # 164=>104647,
 # 165=>104666,

 # 166=>104667,
 # 167=>104663,
 # 168=>104650,
 # 169=>104649,
 # 170=>104640,
 # 171=>104651,
 # 172=>104662,
 # 173=>104671,
 # 174=>104659,
 # 175=>104654,
 # 176=>104645,
 # 177=>104644,
 # 178=>104647,

    # 100790 too low
    # 104693 too high
    # 104651 too low
       # 104671
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

    @matrix_height = @matrix.size
    @matrix_width = @matrix.first.size
  end

  def slide(direction, char, row_idx, col_idx)
    done = false
    actual_row_idx = @matrix_height - row_idx - 1
    actual_col_idx = @matrix_width - col_idx - 1

    if char == 'O'
      until done
        case direction
        when :up
          if row_idx - 1 >= 0 && @matrix[row_idx-1][col_idx] == '.'
            @matrix[row_idx][col_idx] = '.'
            @matrix[row_idx-1][col_idx] = 'O'
            row_idx = row_idx - 1
          else
            done = true
          end
        when :left
          if col_idx - 1 >= 0 && @matrix[row_idx][col_idx-1] == '.'
            @matrix[row_idx][col_idx] = '.'
            @matrix[row_idx][col_idx-1] = 'O'
            col_idx = col_idx - 1
          else
            done = true
          end
        when :down
          if actual_row_idx + 1 <= @matrix_height-1 && @matrix[actual_row_idx+1][col_idx] == '.'
            @matrix[actual_row_idx][col_idx] = '.'
            # @matrix.map {|m| puts m.join('')}
            # sleep 0.5
            @matrix[actual_row_idx+1][col_idx] = 'O'
            # @matrix.map {|m| puts m.join('')}
            # sleep 0.5
            actual_row_idx = actual_row_idx + 1
          else
            done = true
          end
        when :right
          if actual_col_idx + 1 <= @matrix_width-1 && @matrix[row_idx][actual_col_idx+1] == '.'
            @matrix[row_idx][actual_col_idx] = '.'
            @matrix[row_idx][actual_col_idx+1] = 'O'
            actual_col_idx = actual_col_idx + 1
          else
            done = true
          end
        end
      end
    end
  end
end

# if Runner.new('test.txt').run == 64
  puts Runner.new('input.txt').run
# end