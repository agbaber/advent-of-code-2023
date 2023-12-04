class Runner
  def initialize(filename)
    @input = File.read(filename)
    @cards = []
    @won_cards = []
  end

  def run
    @input.each_line do |line|
      regex = /Card(\s)+(?<card_num>\d+): (?<winning_nums>(\d| )+) \| (?<our_nums>(\d| )+)/
      match_data = line.chomp.match(regex)
      @cards << {
        card_num: match_data['card_num'].to_i,
        winning_nums: match_data['winning_nums'].split(' '),
        our_nums: match_data['our_nums'].split(' '),
        points: 0
      }
    end
    @all_cards_count = @cards.size

    @cards.reverse.each do |card|
      get_winners(card)
    end

    @cards.map { |card| card[:points] }.inject(&:+) + @cards.size
  end

  private

  def get_winners(card)
    points = (card[:winning_nums] & card[:our_nums]).size

    if points > 0
      points.times.with_index do |i|
        won_points = @cards[card[:card_num]..card[:card_num] + points - 1].map { |won_card| won_card[:points]}.inject(&:+)
        card[:points] = points + won_points
      end
    end
  end
end

if Runner.new('test.txt').run == 30
  puts Runner.new('input.txt').run
end