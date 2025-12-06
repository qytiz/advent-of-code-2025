input_data = File.read(File.dirname(__FILE__) + '/input_test.txt').split("\n")
highest_combinations = []
input_data.each do |line|
  chars = line.to_s.chars

  highest_digit = chars.sort{|a,b| b <=> a}[0]
  indexes_of_highest_digits = chars.each_with_index.map{|el,index| highest_digit == el ? index : nil}.compact
  puts "indexes_of_highest_digits:#{indexes_of_highest_digits}"
  if indexes_of_highest_digits.count >= 2
    highest_combinations << highest_digit.to_s + highest_digit.to_s
    next
  end

  indexes_of_highest_digits.each do |index|
    if index == chars.size-1
      second_highest_digit = chars.sort{|a,b| b <=> a}.uniq[1]
      puts "string#{line},highest_digit:#{highest_digit}, second_highest_digit:#{second_highest_digit} "
      highest_combinations << second_highest_digit.to_s + highest_digit.to_s
    else
      possible_digits = chars[index+1..]
      highest_second_digit = possible_digits.sort{|a,b| b <=> a}[0]
      highest_combinations << highest_digit.to_s + highest_second_digit.to_s
    end
  end
end

puts "highest_combinations:#{highest_combinations}, sum:#{highest_combinations.map{|items| items.to_i }.sum}"