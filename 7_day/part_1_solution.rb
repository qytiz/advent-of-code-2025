@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
@entry_point = @input_data[0].index("S")
@splits = 0
@flows = [@entry_point]

@input_data[1..].each do |line|
  future_flows = []
  @flows.delete_if do |flow_index|
    if line[flow_index] == '^'
      @splits += 1
      future_flows += [flow_index-1,flow_index+1]
      true
    else
      false
    end
  end
  @flows += future_flows
  @flows.uniq!
end

puts "Splits:#{@splits}"