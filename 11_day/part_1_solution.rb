@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")

@device_names = []
@directions = []
@ways_to_archive = {}

@input_data.each do |row|
  device_name,direction = row.split(":")
  @device_names << device_name
  @directions << direction
end


@directions.map!{|el|el.split(' ')}

first_device_id_name = @device_names.index('you')
@index = 0
@awailible_ways = {@index => @directions[first_device_id_name]}

loop do
  next_step = @index+1
  @awailible_ways[next_step] = []
  @awailible_ways[@index].each do |direction|
    @awailible_ways[next_step] += @directions[@device_names.index(direction)] unless direction == "out"
    if @ways_to_archive[direction].nil?
      @ways_to_archive[direction] = 1
    else
      @ways_to_archive[direction] +=1
    end
  end
  @index = next_step
  break if @awailible_ways[next_step].empty?
end

puts "awailible_ways:#{@ways_to_archive['out']}"