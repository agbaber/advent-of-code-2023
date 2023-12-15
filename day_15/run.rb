class Runner
  def initialize(filename)
    @input = File.read(filename)
    @hash_values = []
  end

  def run
    @steps = @input.chomp.split(',')

    @steps.each do |step|
      @hash_values << get_hash_value(step)
    end

    @hash_values.inject(&:+)
  end

  private

  def get_hash_value(step)
    current_value = 0

    step.codepoints do |c|
      current_value += c
      current_value = current_value * 17
      current_value = current_value % 256
    end

    puts "#{step} becomes #{current_value}"

    current_value
  end
end

if Runner.new('test.txt').run == 1320
  puts Runner.new('input.txt').run
end