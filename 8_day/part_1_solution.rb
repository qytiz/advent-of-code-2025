@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
@coordinates = @input_data.map{|e| e.split(',').map(&:to_f)}
@distances = []
@connections = []
@siquences = []

def calculate_distance(a,b)
  diffirence_in_x = (a[0]-b[0])**2
  diffirence_in_y = (a[1]-b[1])**2
  diffirence_in_z = (a[2]-b[2])**2
  Math.sqrt( diffirence_in_x + diffirence_in_y + diffirence_in_z )
end

class Hash
  def include_combo_of_boxes?(a, b)
    (self[:box_a] == a && self[:box_b] == b) ||
      (self[:box_a] == b && self[:box_b] == a)
  end
end

@coordinates.each_with_index do |coordinate_a, index_a|
  @coordinates.each_with_index do |coordinate_b, index_b|
    next if index_b <= index_a

    @distances << {
      box_a: index_a,
      box_b: index_b,
      distance: calculate_distance(coordinate_a, coordinate_b)
    }
  end
end

@distances.sort_by!{|el|el[:distance]}.each do |distance|
  @connections << [distance[:box_a],distance[:box_b]]
  puts "Making a connect of #{[distance[:box_a],distance[:box_b]]}, with dist:#{distance[:distance]}"
end

siquence_amount = 0
@connections.each do |connection|
  break if siquence_amount == 1000

  matching, non_matching = @siquences.partition { |el| el.include?(connection[0]) || el.include?(connection[1]) }

  if matching.empty?
    @siquences << [connection[0], connection[1]]
    siquence_amount += 1
    next
  end

  merged = matching.flatten.uniq

  merged << connection[0] unless merged.include?(connection[0])
  merged << connection[1] unless merged.include?(connection[1])

  siquence_amount += 1

  @siquences = non_matching + [merged]
end

puts "siq:#{@siquences}}"

@three_bigest_siq = @siquences.sort{|a,b| b.size <=> a.size }[0..2]

puts "three_bigest_siq:#{@three_bigest_siq}"

puts "final answer:#{@three_bigest_siq.map{|el|el.size}.inject(:*)}"