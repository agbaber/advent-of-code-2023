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
          '1'
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

      tally = scored_hand.tally.reject { |k,v| v < 2 }.sort_by { |k,v| [v,k] }.reverse
      j_count = scored_hand.tally.find { |k,v| k == 1 }&.last || 0

      @hands << {
        original_hand: hand,
        scored_hand: scored_hand,
        hand_score: hand_score(scored_hand, tally, j_count),
        tally: tally,
        bet: bet.to_i,
        j_count: j_count
      }
    end

    output = @hands.sort_by do |h|
      [
        h[:hand_score],
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

  def hand_score(scored_hand, tally, j_count)
    other_value_count = scored_hand.reject {|v| v== 1}.uniq.size
    non_j_tally = tally.reject {|a,b| a == 1}

    score = case j_count
    when 5
      :five_of_a_kind
    when 4
      :five_of_a_kind
    when 3
      other_value_count == 1 ? :five_of_a_kind : :four_of_a_kind
    when 2
      case other_value_count
      when 1
        :five_of_a_kind
      when 2
        :four_of_a_kind
      when 3
        :three_of_a_kind
      end
    when 1
      case other_value_count
      when 1
        :five_of_a_kind
      when 2
        if non_j_tally[0] && non_j_tally[0][1] == 3
          :four_of_a_kind
        elsif non_j_tally[0] && (non_j_tally[0][1] == 2 && non_j_tally[1])
          :full_house
        elsif non_j_tally[0]
          :three_of_a_kind
        else
          :pair
        end
      when 3
        :three_of_a_kind
      when 4
        :pair
      end
    when 0
      case non_j_tally&.first&.last
      when nil
        :high_card
      when 5
        :five_of_a_kind
      when 4
        :four_of_a_kind
      when 3
        if non_j_tally.size > 1
          :full_house
        else
          :three_of_a_kind
        end
      when 2
        if non_j_tally.size > 1
          :two_pair
        else
          :pair
        end
      end
    end

    mapping[score] || 0
  end

  def mapping
    {
      five_of_a_kind: 7,
      four_of_a_kind: 6,
      full_house: 5,
      three_of_a_kind: 4,
      two_pair: 3,
      pair: 2,
      high_card: 1
    }
  end
end

if Runner.new('test.txt').run == 5905
  puts Runner.new('input.txt').run
end
