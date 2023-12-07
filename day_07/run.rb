class Runner
  def initialize(filename)
    @input = File.read(filename)
    @hands = []
  end

  def run
    @input.each_line do |line|
      hand, bet = line.split(' ')
      scored_hand = hand.split('').map do |c|
        c = case c
        when 'T'
          '10'
        when 'J'
          '11'
        when 'Q'
          '12'
        when 'K'
          '13'
        when 'A'
          '14'
        else
          c
        end
      end.map(&:to_i)

      tally = scored_hand.tally.reject { |k,v| v < 2 }.sort_by { |k,v| v }.reverse

      @hands << {
        original_hand: hand,
        scored_hand: scored_hand,
        tally: tally,
        bet: bet.to_i
      }
    end
    # puts @hands
    # require 'pry';binding.pry

    output = @hands.sort_by do |h|
      [
        (h[:tally][0] ? h[:tally][0][1] : 0),
        # (h[:tally][0] ? h[:tally][0][0] : 0),
        (h[:tally][1] ? h[:tally][1][1] : 0),
        # (h[:tally][1] ? h[:tally][1][0] : 0),
        h[:scored_hand]
      ].flatten
    end

    output.each_with_index do |o, i|
      o[:rank] = i + 1
    end

    puts output
    result = output.map { |o| o[:rank] * o[:bet]}.inject(&:+)
    puts result
    result

  end

  private

  def score(hand, tally)
    {

    }
  end

end

if Runner.new('test.txt').run == 6440
  puts Runner.new('input.txt').run
end
