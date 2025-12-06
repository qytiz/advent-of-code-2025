input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
highest_combinations = []

def find_indexes_of_highest_digit(chars, next_highest_index)
  highest_digit = chars.sort{|a,b| b <=> a}.uniq[next_highest_index]
  puts "highest_digit:#{highest_digit}"
  chars.each_with_index.map{|el,index| highest_digit == el ? index : nil}.compact
end

def find_highest_element(chars, next_highest_index, limit)
  higher_digit_indexes = find_indexes_of_highest_digit(chars, next_highest_index)
  puts "line: #{chars.join} | higher_digit_indexes.first: #{higher_digit_indexes.first} | chars.count: #{chars.count}"
  return find_highest_element(chars, next_highest_index+1, limit) if higher_digit_indexes.first > chars.count - limit

  puts "higher_digit_indexes:#{higher_digit_indexes.first} | chars:#{chars.join}"
  [chars[higher_digit_indexes.first], chars[higher_digit_indexes.first+1..]]
end

def find_highest_twelve_combination(chars)
  found_elements = []
  current_char = chars.dup

  12.times do |count|
    puts "count:#{count}, chars: #{current_char}"
    highest_element,current_char = find_highest_element(current_char, 0, 12 - found_elements.count)
    found_elements << highest_element
  end

  found_elements
end

input_data.each do |line|
  chars = line.to_s.chars
  highest_combinations << find_highest_twelve_combination(chars).join.to_i
end

puts "highest_combinations:#{highest_combinations},sum:#{highest_combinations.sum}"