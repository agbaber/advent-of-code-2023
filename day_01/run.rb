class Runner
  def initialize(filename)
    @input = File.read(filename)
  end

  def run
  end

  private

end

Runner.new('input.txt').run
