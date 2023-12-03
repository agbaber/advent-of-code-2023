class Runner
  def initialize(filename)
    @input = File.read(filename)
    @games = {}
  end

  def run
    @input.each_line do |line|
      game = line.match(/Game (?<game_number>\d+): (?<results>.+)$/)
      game_number = game['game_number']
      unparsed_results = game['results'].split('; ')
      parsed_results = {}

      unparsed_results.each do |set|
        set.split(', ').each do |colors|
          number, color = colors.split(' ')

          unless parsed_results[color] && parsed_results[color] > number.to_i
            parsed_results[color] = number.to_i
          end
        end
      end

      power = parsed_results.values.inject(&:*)
      @games[game_number] = { power: power }
    end

    puts @games.map { |k,v| v[:power].to_i}.inject(&:+)
  end

  private

end

Runner.new('input.txt').run
