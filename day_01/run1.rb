class Runner
  def initialize(filename)
    @input = File.read(filename)
    @output = []
  end

  def run
    @input.each_line do |line|
      digits = sub_words(line).select { |c| c =~ /\d/ }
      # digits = line.split('').select { |c| c =~ /\d/ }
      value = "#{digits.first}#{digits.last}".to_i
      puts value
      @output << value
    end

    puts @output.inject(&:+)
  end

  private

  def sub_words(input)
    output = []
    split = input.split('')
    split.each_with_index do |l,i|
      case l
      when 'o'
        if split[i..i+2].join == 'one'
          output << '1'
        end
      when 't'
        if split[i..i+2].join == 'two'
          output << '2'
        end

        if split[i..i+4].join == 'three'
          output << '3'
        end
      when 'f'
        if split[i..i+3].join == 'four'
          output << '4'
        end
        if split[i..i+3].join == 'five'
          output << '5'
        end
      when 's'
        if split[i..i+2].join == 'six'
          output << '6'
        end
        if split[i..i+4].join == 'seven'
          output << '7'
        end
      when 'e'
        if split[i..i+4].join == 'eight'
          output << '8'
        end
      when 'n'
        if split[i..i+3].join == 'nine'
          output << '9'
        end
      else
        if l =~ /\d/
          output << l
        end
      end
    end
    
    output

  end
end

# Runner.new('test.txt').run
# Runner.new('test2.txt').run

Runner.new('input.txt').run
