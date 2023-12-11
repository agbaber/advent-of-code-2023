class Runner
  def initialize(filename)
    @input = File.read(filename)
    @original_matrix = []
    @current_char = 1
    @added_rows = 0
    @galaxies = []
  end

  def run
    @input.each_line do |line|
      @original_matrix << line.chomp.split('')
    end

    @original_matrix.map {|m| puts m.join('')}
    @expanded_matrix = @original_matrix.dup

    puts "inserting rows"
    @original_matrix.dup.each_with_index do |line, row_idx|
      if line.uniq.one?
        @expanded_matrix.insert(row_idx+@added_rows, Array.new(line.size, '.'))
        @added_rows +=1
      end
    end
    output = @expanded_matrix.map {|m| puts m.join('')}

    puts "inserting columns"
    @original_matrix.map {|m| puts m.join('')}

    @cols_to_add = []
    @original_matrix.first.size.times do |col|
      col_vals = @original_matrix.map { |row| row[col] }
      puts col_vals.inspect
      if col_vals.uniq.one?
        puts "adding col #{col} (#{col_vals.uniq.inspect})"
        # require 'pry';binding.pry
        @cols_to_add << col
      end
    end

    @cols_to_add.reverse.each do |col|
      @expanded_matrix.each do |line|
        line.insert(col,'.')
      end
    end

    @expanded_matrix.each_with_index do |line, row_idx|
      line.each_with_index do |char, col_idx|
        if char == '#'
          @galaxies << [row_idx, col_idx]
          @expanded_matrix[row_idx][col_idx] = @current_char
          @current_char += 1
        end
      end
    end

    output = @expanded_matrix.map {|m| m.join('')}.join("\n").to_s
    # require 'pry';binding.pry
    if output == File.read('testexpanded.txt').to_s
      puts "yay"
    else
      puts "ohno"
    end

    puts @galaxies.inspect

    distance = 0
    combos = @galaxies.combination(2).to_a
    combos.each do |combo|
      distance += (combo[1][0] - combo[0][0]).abs + (combo[1][1] - combo[0][1]).abs
    end
    distance
  end

  private

end

if Runner.new('test.txt').run == 374
  puts Runner.new('input.txt').run
end