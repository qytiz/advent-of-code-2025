@ranges,@ids = File.read(File.dirname(__FILE__) + '/../input.txt').split("\n\n")
@total_list_of_not_spoiled_ids=[]
@fresh_ids_amount=0


def sort_ranges_by_border_b
  @total_list_of_not_spoiled_ids.sort!{|a,b| b[1] <=> a[1] }
end

def is_included_in_any_range?(id)
  puts "range:#{@total_list_of_not_spoiled_ids}"
  @total_list_of_not_spoiled_ids.each do |range|
    puts "#{range[0] > id}, #{range[1] < id}, #{range[1] >= id}"
    next if range[0] > id
    return if range[1] < id

    return true if range[1] >= id
  end
  
  false
end

@ranges.split("\n").each do |line|
  border_a,border_b = line.split('-').map{|e|e.to_i}
  puts "border_a:#{border_a}, border_b:#{border_b}"
  @total_list_of_not_spoiled_ids << [border_a,border_b]
end

sort_ranges_by_border_b

@ids.split("\n").each do |id|
  puts "test"
  @fresh_ids_amount +=1 if is_included_in_any_range?(id.to_i)
end

puts "total_list_of_not_spoiled_ids:#{@total_list_of_not_spoiled_ids}"
puts "fresh_ids_amount:#{@fresh_ids_amount}"