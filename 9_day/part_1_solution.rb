@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
@coordinates_list = @input_data.map{|e| e.split(',').map(&:to_i)}
@biggest_differences = []

@coordinates_list.each do |coordinates_of_first_title|
  differences = []
  @coordinates_list.each do |coordinates_of_second_title|
    next if coordinates_of_first_title == coordinates_of_second_title
    x_diff = (coordinates_of_first_title[0] - coordinates_of_second_title[0]).abs
    y_diff = (coordinates_of_first_title[1] - coordinates_of_second_title[1]).abs
    differece = Math.sqrt(x_diff*2+y_diff*2)
    differences << [[coordinates_of_first_title,coordinates_of_second_title],[x_diff+1,y_diff+1],differece]
  end
  @biggest_differences << differences.sort{|a,b| b[2] <=> a[2]}[0]
end
puts "@biggest_differences: #{@biggest_differences}"

biggest_difference = @biggest_differences.sort{|a,b| b[2] <=> a[2]}[0]

puts "biggest_diff #{biggest_difference}"

biggest_square_size = biggest_difference[1].inject(:*)

puts "biggest_square_size: #{biggest_square_size}"