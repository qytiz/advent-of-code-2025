input_data = File.read(File.dirname(__FILE__) + '/../input.txt').split("\n")
@current_position = 50
@prev_position = 50
@zero_passed = false
@difference = 0

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
    @prev_position = @current_position
    @current_position += amount
    reduce_position_if_needed
  else
    @prev_position = @current_position
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

  decreased_from = @prev_position
  while current_position_higher_than_max?
    @zero_passed = true

    @current_position -= MAX_NUMBER + 1

    puts "Adding zero" if @current_position != 0
    @zeros_amount += 1 if @current_position != 0
    decreased_from = -1
  end
end

def increase_position_if_needed
  return if !current_position_lower_than_lower?

  incresed_from = @prev_position
  while current_position_lower_than_lower?
    @zero_passed = true

    @zeros_amount += 1 if @current_position != 0 && incresed_from != 0
    @current_position += MAX_NUMBER + 1
    incresed_from = -1
  end
end

input_data.each do |line|
  if line[0] == '#'
    puts "Skipping comment line: #{line}"
    next
  end

  @difference = 0
  @zero_passed = false
  calculate_new_direction(line.to_s[0])
  amount = line.to_s[1..].to_i
  calculate_next_pos(amount)
  @difference = amount
  puts "difference: #{@difference} | current position: #{@current_position} | prev position: #{@prev_position} | direction: #{@direction}"
  @zeros_amount += 1 if @current_position == 0 #&& ( !@zero_passed || ( @difference >= 100 ) )
  puts "current position: #{@current_position} | zeros amount: #{@zeros_amount}"
end

puts "Total zeros encountered: #{@zeros_amount}"