input_data = File.read(File.dirname(__FILE__) + '/../input.txt').split(",")
repeats = []

input_data.each do |line|
  id_a, id_b = line.strip.split("-")
  ids = (id_a.to_i..id_b.to_i).to_a
  ids.each do |id|
    next if id.to_s.size.odd?
    half_delimetr = id.to_s.size / 2
    first_half = id.to_s[0..half_delimetr-1]
    second_half = id.to_s[half_delimetr..]
    repeats << id if second_half == first_half
    puts "ID: #{id}, first half: #{first_half}, second half: #{second_half}"
  end
end

puts "Repeats amount: #{repeats}, sum: #{repeats.sum}"