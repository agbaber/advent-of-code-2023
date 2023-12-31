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

      if parsed_results['red'] > 12 || parsed_results['green'] > 13 || parsed_results['blue'] > 14
        @games[game_number] = { invalid: true }
      else
        @games[game_number] = { invalid: false }
      end
    end

    puts @games.select { |k,v| !v[:invalid] }.map { |k,v| k.to_i}.inject(&:+)
  end

  private

end

Runner.new('input.txt').run
