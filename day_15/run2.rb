class Runner
  def initialize(filename)
    @input = File.read(filename)
    @hash_values = []
    @boxes = {}

    #   {
    #     1 => [
    #       { abc => 5 }
    #     ]
    #   },
    #   {
    #     2 => [
    #       { esf => 7 }
    #     ]
    #   }
  end

  def run
    @steps = @input.chomp.split(',')

    @steps.each do |step|
      @hash_values << get_hash_value(step)
    end

    @hash_values.each do |h|
      box = @boxes[h[:box]]
      label = h[:label]
      focal_length = h[:focal_length]

      if box
        existing_lens_idx = box.find_index {|k| k.keys.first == label }
      end

      if focal_length
        if existing_lens_idx
          box[existing_lens_idx][label] = focal_length
        else
          if box
            box << { label => focal_length }
          else
            @boxes[h[:box]] = [{ label => focal_length }]
          end
        end
      else
        # require 'pry';binding.pry
        if existing_lens_idx
          box.delete_at(existing_lens_idx)
        end
      end

      puts @boxes.inspect
      puts "\n"
    end

    @boxes.map do |box|
      box_num = box[0]
      lenses = box[1]

      box_power = 0

      lenses.each_with_index do |lens, i|
        box_power += (box_num + 1) * (i + 1) * lens.values.first
      end

      box_power
    end.inject(&:+)
    # require 'pry';binding.pry
    # puts @hash_values.inspect
  end

  private

  def get_hash_value(step)
    current_value = 0
    regexp = step.match(/(?<letters>\w+)(=|-)(?<focal_length>\d?)/)
    focal_length = regexp['focal_length']

    regexp['letters'].codepoints do |c|
      current_value += c
      current_value = current_value * 17
      current_value = current_value % 256
    end

    puts "#{step} becomes #{current_value}"

    {
      box: current_value,
      focal_length: focal_length.empty? ? nil : focal_length.to_i,
      label: regexp['letters']
    }
  end
end

if Runner.new('test.txt').run == 145
  puts Runner.new('input.txt').run
end