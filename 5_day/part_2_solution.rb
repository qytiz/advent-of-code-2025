require 'byebug'

@ranges,_ids = File.read(File.dirname(__FILE__) + '/input.txt').split("\n\n")
@total_list_of_not_spoiled_ids=[]
@fresh_ids_amount=0


def sort_ranges_by_border_b
  @total_list_of_not_spoiled_ids.sort{|a,b| a[1] <=> b[0] }
end

def mutate_range(sorted_array)
  sorted_array.map!.with_index do |range, index|
    next_element = sorted_array[index+1]
    next range unless next_element
    next range if range.nil? || sorted_array[index+1][0] > range[1]
    sorted_array[index+1] = nil
    [[next_element[0],range[0]].min,[next_element[1],range[1]].max]
  end.compact
end


@ranges.split("\n").each do |line|
  border_a,border_b = line.split('-').map{|e|e.to_i}
  @total_list_of_not_spoiled_ids << [border_a,border_b]
end


sorted_array = sort_ranges_by_border_b
while sorted_array != @total_list_of_not_spoiled_ids
  @total_list_of_not_spoiled_ids = mutate_range(sorted_array)
  sorted_array = sort_ranges_by_border_b
end


puts "total_list_of_not_spoiled_ids:#{@total_list_of_not_spoiled_ids}"
puts "total_el is:#{@total_list_of_not_spoiled_ids.map{|el| el[1]+1 - el[0]}.sum}"