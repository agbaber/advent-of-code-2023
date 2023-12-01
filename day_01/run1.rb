class Runner
  def initialize(filename)
    @input = File.read(filename)
    @output = []
  end

  def run
    @input.each_line do |line|
      digits = line.split('').select { |c| c =~ /\d/ }
      value = "#{digits.first}#{digits.last}".to_i
      puts value
      @output << value
    end

    puts @output.inject(&:+)
  end

  private

  end
end

# Runner.new('test.txt').run
# Runner.new('test2.txt').run

Runner.new('input.txt').run
