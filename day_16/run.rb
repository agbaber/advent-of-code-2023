class Runner
  def initialize(filename)
    @input = File.read(filename)
    @matrix = []
    @beams = [{current_loc: [0,0], current_dir: :right, previous: [], exited_or_looped: false}]
  end

  def run
    parse_input

    until @beams.all? {|b| b[:exited_or_looped]}
      @beams.each_with_index do |beam, i|
        Beam.new(beam[:current_loc], beam[:current_dir], beam[:previous], beam[:exited_or_looped])

        unless beam[:exited_or_looped]

          next_loc = case beam[:current_dir]
            when :right
              [beam[:current_loc][0], beam[:current_loc][1]+1]
            when :left
              [beam[:current_loc][0], beam[:current_loc][1]-1]
            when :up
              [beam[:current_loc][0] + 1 , beam[:current_loc][1]]
            when :down
              [beam[:current_loc][0] - 1 , beam[:current_loc][1]]
          end

          matrix_next_loc = if @matrix[next_loc[0]]
            @matrix[next_loc[0]][next_loc[1]]
          end

          if matrix_next_loc
            matrix_next_loc[:beams] << beam[:current_dir]
          else
            beam[:exited_or_looped] = true
          end

          case matrix_next_loc[:char]
          when '.'
          when '|'
            if [:right, :left].include?(beam[:current_dir])
              up_line = @matrix[matrix_next_loc[0] - 1]
              down_line = @matrix[matrix_next_loc[0] + 1]

              if up_line
                @beams[i][:current_loc] = [@matrix[matrix_next_loc[0] - 1], matrix_next_loc[1]]
              end

              if down_line
                @beams << {current_loc: [@matrix[matrix_next_loc[0] + 1], matrix_next_loc[1]], current_dir: :down, previous: [], exited_or_looped: false}
              end
            end
          when '\\'

          when '/'

          when '-'
          end
        end

        puts @matrix.map {|m| m[:char]}.join
        puts @beams.inspect
      end
    end
  end

  private

  class Beam
    attr_reader :created_beam, :current_loc, :current_dir, :previous, :exited_or_looped

    def initialize(current_loc, current_dir, previous, exited_or_looped)
      @current_loc = current_loc
      @current_dir = current_dir
      @previous = previous
      @exited_or_looped = false
    end

    def move(row, col)
    end

    private

  end

  def parse_input
    @input.each_line do |line|
      mapped_line = []
      line.split('').each do |char|
        mapped_line << {char: char, beams: []}
      end

      @matrix << mapped_line
    end
  end
end

if Runner.new('test.txt').run ==1
  puts Runner.new('input.txt').run
end
