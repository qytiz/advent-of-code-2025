@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
@total_rows = @input_data.count
@final_score = 0

@numbers_rows = @input_data[..@total_rows-2].map{|e|e.split("")}
@actions = @input_data.last.split("")

def longitude_untill_next_sign(current_sign_index)
  return @actions[current_sign_index..].count if @actions[current_sign_index+1..].reject{|el| el==" "}.empty?

  @actions[current_sign_index+1..].each_with_index do |value, index|
    break index if value != " "
  end
end

def take_full_numers(longitude,current_offset)
  numbers = @numbers_rows.map do |row|
    row[current_offset..longitude-1+current_offset]
  end

  elements = []
  longitude.times.with_index do |index|
    elements << numbers.map{|el|el[index]}
  end

  elements.map{_1.join.to_i}
end

current_offset=0
@actions.each_with_index do |action,index|
  next if action == " "

  longitude = longitude_untill_next_sign(index)
  @final_score += take_full_numers(longitude,current_offset).inject(action.to_sym)
  current_offset += longitude+1
end



puts "@numbers_rows[0]:#{@numbers_rows.first.inspect}"
puts "sum:#{@final_score}"