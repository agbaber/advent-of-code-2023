class Runner
  def initialize(filename)
    @input = File.read(filename)
    @sets = {}
  end

  def run
    @input.each_line.with_index do |line, i|
      @sets[i] = [line.split(' ').map(&:to_i)]
    end

    @sets.each_with_index do |set, idx|
      until @sets[idx][-1].uniq.one? && @sets[idx][-1].uniq[0] == 0
        new_set = []

        current_array(set).each_with_index do |s, i|
          if current_array(set)[i+1]

            new_set << current_array(set)[i+1] - s
          end
        end

        set[-1] << new_set
      end
    end

    @sets.each do |set|
      arrays = set[1].reverse
      arrays.each_with_index do |array, i|

        # unless array.uniq == [0]
          if arrays[i+1]
            arrays[i+1].insert(0, arrays[i+1][0] - array[0])
          end
        # end
      end
    end

    puts @sets.inspect
    @sets.map do |set|
      set[1][0][0]
    end.inject(&:+)
  end

  private

  def current_array(set)
    set[-1][-1]
  end

end

if Runner.new('test.txt').run == 2
  puts Runner.new('input.txt').run
end