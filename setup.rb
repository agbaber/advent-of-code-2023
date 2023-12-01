(1..24).to_a.each do |num|
  day = "%.2i" % num
  Dir.mkdir("day_#{day}")
  File.open("day_#{day}/input.txt", "w")

  File.open("day_#{day}/run.rb", "w") do |f|
    text = <<~EOF
      class Runner
        def initialize(filename)
          @input = File.read(filename)
        end

        def run
        end

        private

      end

      Runner.new('input.txt').run
    EOF

    f.write(text)
  end
end