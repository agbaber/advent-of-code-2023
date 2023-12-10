class Runner
  def initialize(filename)
    @input = File.read(filename)
    @matrix = []
    @visited_coords = []
    @visited_count = 0
  end

  def run
    @input.each_line do |line|
      @matrix << line.chomp.split('')
    end

    @matrix.each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        if col == 'S'
          @start = [row_i, col_i]
        end
      end
    end

    @starting_points = find_starting_points
    puts "Starting:"
    puts @starting_points.inspect
    puts "\n"
    @visited_coords << @start
    @current_coords = @starting_points.first

    until @current_coords == @starting_points.last
      @visited_coords << @current_coords
      next_c = next_coords(@current_coords)
      @visited_count += 1
      # puts 'nextc'
      # puts next_c.inspect
      # require 'pry';binding.pry
      puts "currently at #{@current_coords} (#{@matrix[@current_coords[0]][@current_coords[1]]})"
      puts "last visited #{@visited_coords.last}"
      puts "connected to #{next_c.inspect}"
      @current_coords = next_c.reject { |v| v == @visited_coords[-2]}.first
      # require 'pry';binding.pry
      puts "up next: #{@current_coords}"
      # puts @matrix[@current_coords[0]][@current_coords[1]]
    end
    @visited_coords << @current_coords

    # find_connection
    # puts @start.inspect

    
    @inside_count = 0
    @matrix

    @matrix.each_with_index do |row, row_i|
      @inside_perimeter = false
      row.each_with_index do |col, col_i|
        if @visited_coords.include?([row_i,col_i]) && ['|','F','7'].include?(col)
          @inside_perimeter = !@inside_perimeter
        elsif @visited_coords.include?([row_i,col_i])
        elsif @inside_perimeter
          @inside_count += 1
          @matrix[row_i][col_i] = 'I'
        end
      end
    end
    
    @matrix.map {|m| puts m.join('')}
    @inside_count
  end

  private

  def find_starting_points
    start_row, start_col = @start

    [
      [start_row + 1, start_col],
      [start_row, start_col + 1],
      [start_row - 1, start_col],
      [start_row, start_col - 1]
    ].map do |a,b|
      if @matrix[a][b] && next_coords([a,b]).include?(@start)
        [a,b]
      end
    end.compact
  end

  def next_coords(current_coords)
    row, col = current_coords
    puts current_coords.inspect

    if @matrix[row]
      current_sym = @matrix[row][col]
      linked_coords = []

      case current_sym
      when '|'
        linked_coords << [row + 1, col]
        linked_coords << [row - 1, col]
      when '-'
        linked_coords << [row, col + 1]
        linked_coords << [row, col - 1]
      when 'L'
        linked_coords << [row - 1, col]
        linked_coords << [row, col + 1]
      when 'J'
        linked_coords << [row - 1, col]
        linked_coords << [row, col - 1]
      when '7'
        linked_coords << [row, col - 1]
        linked_coords << [row + 1, col]
      when 'F'
        linked_coords << [row, col + 1]
        linked_coords << [row + 1, col]
      end

      linked_coords
    end
  end

end

# Runner.new('test2.txt').run == 4
  puts Runner.new('input.txt').run
# end

#498 too high