class Runner
  def initialize(filename)
    @input = File.read(filename)
    @directions = []
    @dug_points = [[0,0]]
    @matrix = []
  end

  def run
    parse_input

    @directions.each do |direction|
      dig(direction[:direction], direction[:distance])
    end

    max_row = @dug_points.max_by {|a,b| a}[0] + 1
    max_col = @dug_points.max_by {|a,b| b}[1] + 1

    min_row = @dug_points.min_by {|a,b| a}[0]
    min_col = @dug_points.min_by {|a,b| b}[1]

    @dug_points.each_with_index do |pt, i|
      @dug_points[i] = [pt[0]+min_row.abs, pt[1] + min_col.abs]
    end

    (max_row + min_row.abs).times do
      row = []

      (max_col + min_col.abs).times do
        row << '.'
      end

      @matrix << row
    end

    @dug_points.each do |row, col|
      if @matrix[row]
        @matrix[row][col] = '#'
      else
        require 'pry';binding.pry
      end
    end

    
    @dup_matrix = []
    @matrix.each do |row|
      @dup_matrix << row.dup
    end

    # shoelace


    require 'pry';binding.pry

    shoelace_formula(@dug_points).to_i

    # @matrix.map { |m| puts m.join('') }
    # puts "\n"
    # @dup_matrix.each_with_index do |line, line_idx|
    #   @inside = false
    #   @wrote_inside = nil

    #   line.each_with_index do |col, col_idx|
    #     if col == '.'
    #       if @inside
    #         @matrix[line_idx][col_idx] = '#'
    #         @wrote_inside = true
    #       end
    #     elsif col == '#'
    #       if (@dup_matrix[line_idx][col_idx-1] == '.' || col_idx.zero?)
    #         @inside = !@inside

    #         if @inside
    #           @wrote_inside = false
    #         end
    #       elsif !@wrote_inside && @dup_matrix[line_idx][col_idx+1] == '.'
    #         @inside = false
    #       end
    #     end
    #   end
    # end

    # @matrix.map { |m| puts m.join('') }
    # @matrix.map { |m| m.tally['#'] }.inject(&:+)


    # count = (@matrix.size * @matrix.first.size) - outside_count
    # puts count
    # count
  end

  private

  def dig(direction, distance)
    current_loc = @dug_points.last

    case direction
    when 'U'
      (current_loc[0]-distance..current_loc[0]-1).to_a.reverse.each do |pt|
        @dug_points << [pt, current_loc[1]]
      end
    when 'D'
      (current_loc[0]+1..current_loc[0]+distance).to_a.each do |pt|
        @dug_points << [pt, current_loc[1]]
      end
    when 'L'
      (current_loc[1]-distance..current_loc[1]-1).to_a.reverse.each do |pt|
        @dug_points << [current_loc[0], pt]
      end
    when 'R'
      (current_loc[1]+1..current_loc[1]+distance).to_a.each do |pt|
        @dug_points << [current_loc[0], pt]
      end
    end
  end

  def parse_input
    @input.each_line do |line|
      matchdata = line.match(/(?<direction>\w) (?<distance>\d+) \(#(?<hex_color>\w+)\)/)
      @directions << {
        direction: matchdata['direction'],
        distance: matchdata['distance'].to_i,
        hex_color: matchdata['hex_color']
      }
    end
  end


  def shoelace_formula(vertices)
    n = vertices.length
    sum1 = 0
    sum2 = 0

    vertices.each_with_index do |vertex, i|
      next_vertex = vertices[(i + 1) % n] # Ensures the loop for the last vertex connects to the first
      sum1 += vertex[0] * next_vertex[1]
      sum2 += vertex[1] * next_vertex[0]
    end

    (sum1 - sum2).abs / 2.0
  end
end

if Runner.new('test.txt').run == 62
  puts Runner.new('input.txt').run
end

# 47627 too high