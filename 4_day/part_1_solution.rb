@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
@paper_positions = []
@total_near = []

def located_near?(pos,pos2)
  pos - 1 == pos2 || pos + 1 == pos2 
end

def near_or_same?(pos,pos2)
  located_near?(pos,pos2) || pos == pos2
end

def find_nearby_papers(current_paper_position)
  amount_of_occupied_space=0
  @paper_positions.each do |position|
    next if position[0] == current_paper_position[0] && current_paper_position[1] == position[1]
    next if current_paper_position[0]-2 >= position[0]
    next if current_paper_position[1]-2 >= position[1] || current_paper_position[1] + 2 == position[1]

    return amount_of_occupied_space if current_paper_position[0] + 2 <= position[0]

    puts "#{current_paper_position} checking the position:#{position}"
    if near_or_same?(position[0],current_paper_position[0])
      amount_of_occupied_space += 1 if near_or_same?(position[1],current_paper_position[1])
    end
  end
  puts "current_paper_position:#{current_paper_position}, amount_of_occupied_space:#{amount_of_occupied_space}"
  amount_of_occupied_space
end

@input_data.each_with_index do |line, line_number|
  line.chars.each_with_index do |char, position_number|
    next unless char == "@"
    @paper_positions << [line_number,position_number]
  end
end

@paper_positions.each do |pos|
  @total_near << pos if find_nearby_papers(pos) < 4
end

puts "@paper_positions:#{@paper_positions}, count#{@paper_positions.count}}"
puts "@total_near:#{@total_near}, count#{@total_near.count}"