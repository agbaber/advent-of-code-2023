class Runner
  def initialize(filename)
    @input = File.read(filename)
    @output = []
  end

  def run
    @input.each_line do |line|
      matches = line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/)

      converted = matches.flatten.map { |m| m = convert(m) }
      @output << "#{converted.first}#{converted.last}".to_i
    end

    puts @output.inject(&:+)
  end

  private

  def convert(value)
    if value =~ /\d/
      value
    else
      mapping[value]
    end
  end

  def mapping
    {
      'one' => '1',
      'two' => '2',
      'three' => '3',
      'four' => '4',
      'five' => '5',
      'six' => '6',
      'seven' => '7',
      'eight' => '8',
      'nine' => '9'
     }
  end
end

# Runner.new('test.txt').run
# Runner.new('test2.txt').run

Runner.new('input.txt').run
