class Runner
  def initialize(filename)
    @input = File.read(filename)
    @ratings = []
    @workflows = {}
  end

  def run
    parse_input

    @ratings.each_with_index do |rating, i|
      workflow = 'in'

      until ['A','R'].include?(workflow)
        workflow = get_result(workflow, rating)
      end

      @ratings[i] << workflow
    end

    score = 0
    @ratings.select {|r| r[-1] == 'A'}.each do |rating|
      rating.each do |s|
        score += s.split('=')[1].to_i || 0
      end
    end

    score
  end

  private

  def get_result(workflow, rating)
    x = nil
    m = nil
    a = nil
    s = nil

    rating.each do |r|
      eval("#{r};")
    end

    first_result = eval(@workflows[workflow][0]) ? @workflows[workflow][1].split(',')[0] : @workflows[workflow][1].split(',')[1]

    if first_result.include?('<') || first_result.include?('>')
      second_result = eval(first_result) ? @workflows[workflow][2].split(',')[0] : @workflows[workflow][2].split(',')[1]
    end

    if second_result&.include?('<') || second_result&.include?('>')
      third_result = eval(second_result) ? @workflows[workflow][3].split(',')[0] : @workflows[workflow][3].split(',')[1]
    end

    third_result || second_result || first_result
  rescue NoMethodError
    require 'pry';binding.pry
  end

  def parse_input
    # require 'pry';binding.pry
    workflows, ratings = @input.split("\n\n")

    workflows.split("\n").each do |workflow|
      match_data = workflow.match(/(?<type>\w+){(?<tests>.+)}/)
      type = match_data['type']
      tests = match_data['tests'].split(':')

      # require 'pry';binding.pry
      @workflows[type] = tests
    end

    ratings.split("\n").each do |rating|
      @ratings << rating.gsub('{','').gsub('}','').split(',')
      # match_data = rating.match(/{(?<first>\w)=(?<first_v>\d+),(?<second>\w)=(?<second_v>\d+),(?<third>\w)=(?<third_v>\d+),(?<fourth>\w)=(?<fourth_v>\d+)}/)
      # @ratings << {
      #   match_data['first'] => match_data['first_v'].to_i,
      #   match_data['second'] => match_data['second_v'].to_i,
      #   match_data['third'] => match_data['third_v'].to_i,
      #   match_data['fourth'] => match_data['fourth_v'].to_i,
      # }
    end
  end
end

if Runner.new('test.txt').run == 19114
  puts Runner.new('input.txt').run
end