@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
@total_rows = @input_data.count
@final_score = 0

@numbers_rows = @input_data[..@total_rows-2].map{|e|e.split(" ").map(&:to_i)}
@actions = @input_data.last.split(" ")

@actions.each_with_index do |action, number_of_action|
  @final_score += @numbers_rows.map{|numbers| numbers[number_of_action] }.inject(action.to_sym)
end

puts "sum:#{@final_score}"