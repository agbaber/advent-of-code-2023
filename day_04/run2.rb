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
        our_nums: match_data['our_nums'].split(' ')
      }
    end
    @all_cards_count = @cards.size

    @cards.each do |card|
      get_winners(card)
    end

    until @won_cards.empty?
      won_clone = @won_cards.dup
      @won_cards = []
      won_clone.each do |card|
        get_winners(card)
      end
    end

    @all_cards_count
  end

  private

  def get_winners(card)
    points = (card[:winning_nums] & card[:our_nums]).size
    card[:points] = points
    points.times.with_index do |i|
      won_card = @cards.select { |all_card| all_card[:card_num] == (card[:card_num] + i + 1) }.first
      @won_cards << won_card
      puts "won card #{won_card[:card_num]} from #{card[:card_num]}"
      @all_cards_count += 1
    end
  end
end

if Runner.new('test.txt').run == 30
  puts Runner.new('input.txt').run
end