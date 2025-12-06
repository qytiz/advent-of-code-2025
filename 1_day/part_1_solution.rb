input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
puts "Input data: #{input_data}"
@current_position = 50
@zeros_amount = 0
@direction = true

MAX_NUMBER = 99
LOWER_NUMBER = 0

def calculate_new_direction(new_direction)
  case new_direction
    when 'L'
      @direction = false
    when 'R'
      @direction = true
  end
end

def calculate_next_pos(amount)
  if @direction
    @current_position += amount
    reduce_position_if_needed
  else
    @current_position -= amount
    increase_position_if_needed
  end
end

def current_position_higher_than_max?
  @current_position > MAX_NUMBER
end

def current_position_lower_than_lower?
  @current_position < LOWER_NUMBER
end

def reduce_position_if_needed
  return unless current_position_higher_than_max?

  while current_position_higher_than_max?
    @current_position -= MAX_NUMBER + 1
  end
end

def increase_position_if_needed
  return if !current_position_lower_than_lower?

  while current_position_lower_than_lower?
    @current_position += MAX_NUMBER + 1
  end
end

input_data.each do |line|
  puts "inbound line: #{line}"
  calculate_new_direction(line.to_s[0])
  amount = line.to_s[1..].to_i
  puts "ammount: #{amount}, direction: #{@direction ? 'R' : 'L'}"
  calculate_next_pos(amount)
  puts "current position: #{@current_position}"
  @zeros_amount += 1 if @current_position == 0
end

puts "Total zeros encountered: #{@zeros_amount}"