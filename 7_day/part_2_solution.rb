@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
@entry_point = @input_data[0].index("S")

@flows = [{@entry_point => 1}]

# All code bellow basicly calculates ammount of possible ways to the end point
# Based on the amount of previous ways split by 2 identicly hard ways (Row 35)
# After it we may recieve two paths to the same point with X steps each,
# We combine them and get a sum of it as a ammount to ways to this specific point (Row 19)
# Than repeat same logic untill file ends
# At the end of file combine amounts of all pathes to each reachable point 

def flows_include_current_key?(flows,key)
  flows.map do |flow|
    return true if flow.keys[0] == key
  end 
  false
end

def combine_flows(future_flows)
  counted_flows=[]
  future_flows.each do |flow|
    next if counted_flows.map{|counted_flow| counted_flow.keys[0]}.include?(flow.keys[0])
    next if future_flows.map{|future_flow| future_flow.keys[0]}.select{|future_flow_key| future_flow_key == flow.keys[0]}.count == 1

    counted_flows << {flow.keys[0] => future_flows.select{|el| el.keys[0]==flow.keys[0]}.map{|el| el.values[0]}.sum}
  end

  future_flows.delete_if do |el|
    flows_include_current_key?(counted_flows,el.keys[0])
  end + counted_flows
end

@input_data[1..].each do |line|
  future_flows = []
  @flows.delete_if do |flow|
    if line[flow.keys[0]] == '^'
      future_flows += [{flow.keys[0]-1 => flow.values[0]},{flow.keys[0]+1 => flow.values[0]}]
      true
    else
      false
    end
  end

  future_flows = combine_flows(future_flows)
  @flows += future_flows
end

@timeflow = @flows.map{|el| el.values[0] }.sum

puts "timeflows:#{@timeflow}"