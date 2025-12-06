input_data = File.read(File.dirname(__FILE__) + '/input.txt').split(",")
repeats = []

def find_all_options(id)
  stringifyed_id = id.to_s
  variants = []
  possible_options = (stringifyed_id.size / 2)

  possible_options.times do |index|
    variants << stringifyed_id[0..index]
  end
  variants
end

def value_repeatable?(id,possible_options)
  possible_options.each do |option|
    portions = id.to_s.chars.each_slice(option.size)
    return true if portions.uniq.count == 1
  end
  
  false
end

input_data.each do |line|
  id_a, id_b = line.strip.split("-")
  ids = (id_a.to_i..id_b.to_i).to_a
  ids.each do |id|
    next if id.to_s.size == 1

    possible_options = find_all_options(id)
    repeats << id if value_repeatable?(id,possible_options)
  end
end

puts "Repeats amount: #{repeats}, sum: #{repeats.sum}"