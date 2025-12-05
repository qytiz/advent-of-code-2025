@input_data = File.read(File.dirname(__FILE__) + '/../input.txt').split("\n")
@paper_positions = []
@to_remove = []
@removable_count = 0

def located_near?(pos,pos2)
  pos - 1 == pos2 || pos + 1 == pos2 
end

def near_or_same?(pos,pos2)
  located_near?(pos,pos2) || pos == pos2
end

def sanitize_line(input_data)
  input_data.each_with_index do |line,line_index|
    applyible_removes = @to_remove.map{|element| element[0] == line_index ? element[1] : nil}.compact
    next if applyible_removes.empty?
    applyible_removes.each do |remove_index|
      line[remove_index] = "."
    end
  end

  puts "input_data:#{input_data}"
  input_data
end
String.new('r')
def find_nearby_papers(current_paper_position)
  amount_of_occupied_space=0
  @paper_positions.each do |position|
    next if position[0] == current_paper_position[0] && current_paper_position[1] == position[1]
    #puts "pos:#{position},current_paper_position:#{current_paper_position} | current_paper_position[0]-2 >= position[0]:#{current_paper_position[0]-2 >= position[0]}"
    next if current_paper_position[0]-2 >= position[0]
    #puts "pos:#{position},current_paper_position:#{current_paper_position} | current_paper_position[1]-2 >= position[1]:#{current_paper_position[1]-2 >= position[1]}"
    #puts "pos:#{position},current_paper_position:#{current_paper_position} | current_paper_position[1] + 2 == position[1]:#{current_paper_position[1] + 2 == position[1]}"
    next if current_paper_position[1]-2 >= position[1] || current_paper_position[1] + 2 == position[1]

    #puts "pos:#{position},current_paper_position:#{current_paper_position} | current_paper_position[0] + 2 == position[0]:#{current_paper_position[0] + 2 == position[0]}"
    return amount_of_occupied_space if current_paper_position[0] + 2 <= position[0]

    #puts "#{current_paper_position} checking the position:#{position}"
    if near_or_same?(position[0],current_paper_position[0])
      amount_of_occupied_space += 1 if near_or_same?(position[1],current_paper_position[1])
    end
  end
  puts "current_paper_position:#{current_paper_position}, amount_of_occupied_space:#{amount_of_occupied_space}"
  amount_of_occupied_space
end

def check_if_possible_to_remove_any(input_data)
  input_data.each_with_index do |line, line_number|
    line.chars.each_with_index do |char, position_number|
      next unless char == "@"
      @paper_positions << [line_number,position_number]
    end
  end

  @paper_positions.each do |pos|
    @to_remove << pos if find_nearby_papers(pos) < 4
  end

  return if @to_remove.empty?

  line = sanitize_line(input_data)
  @removable_count += @to_remove.count

  puts "@paper_positions:#{@paper_positions}, count#{@paper_positions.count}}"
  puts "@to_remove:#{@to_remove}, count#{@to_remove.count}"
  
  @to_remove = []
  @paper_positions = []
  check_if_possible_to_remove_any(line)
end

check_if_possible_to_remove_any(@input_data)
puts "Removable_count:#{@removable_count}"