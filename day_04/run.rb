class Runner
  def initialize(filename)
    @input = File.read(filename)
    @cards = []
  end

  def run
    @input.each_line do |line|
      regex = /Card(\s)+(?<card_num>\d+): (?<winning_nums>(\d| )+) \| (?<our_nums>(\d| )+)/
      match_data = line.chomp.match(regex)
      @cards << {
        card_num: match_data['card_num'],
        winning_nums: match_data['winning_nums'].split(' '),
        our_nums: match_data['our_nums'].split(' ')
      }
    end

    @cards.each do |card|
      card[:points] = CardChecker.new(card).get_points
    end

    @cards.map { |card| card[:points] || 0 }.inject(&:+)
  end

  private

  class CardChecker
    def initialize(card)
      @card = card
      @winning_nums = card[:winning_nums]
      @our_nums = card[:our_nums]
    end

    def get_points
      winning_num_count = (@winning_nums & @our_nums).size

      if winning_num_count > 0
        @score = 2 ** (winning_num_count - 1)
      end

      @score
    end
  end
end

if Runner.new('test.txt').run == 13
  puts Runner.new('input.txt').run
end