@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")
@coordinates_list = @input_data.map{|e| e.split(',').map(&:to_i)}
@biggest_differences = []
@sides = []
@biggest_area = 0

class Range
  def middle
    new_begin = self.begin + 1
    new_end = self.end - 1 

    return nil if new_begin > new_end

    (new_begin..new_end)
  end

    def intersects?(other)
    a_begin = self.begin
    a_end   = self.end
    b_begin = other.begin
    b_end   = other.end

    return true if cover?(b_begin) || cover?(b_end)
    return true if other.cover?(a_begin) || other.cover?(a_end)

    false
  end
end

@coordinates_list.each_with_index do |coordinates, index|
  next_point = @coordinates_list[index+1]
  next_point = @coordinates_list[0] if next_point.nil?
  if coordinates[0] == next_point[0]
    y_range = if coordinates[1] > next_point[1]
      (next_point[1]..coordinates[1])
     else
       (coordinates[1]..next_point[1])
      end
      @sides << [coordinates[0], y_range]
    else
      x_range = if coordinates[0] > next_point[0]
      (next_point[0]..coordinates[0])
     else
       (coordinates[0]..next_point[0])
    end
      @sides << [x_range, coordinates[1]]
  end
end

puts "@sides:#{@sides}"

def one_line?(coordinates)
  coordinates.each_with_index do |coordinate,index|
    return true if coordinates[0][index] == coordinates[1][index]
  end

  false
end

def lays_on_the_side?(side, coordinates)
  side.each_with_index.all? do |point_of_side, index|
    if point_of_side.is_a?(Integer)
      coordinates[index] == point_of_side
    else
      point_of_side.include?(coordinates[index])
    end
  end
end

def included_in_figure?(coordinates)
  px, py = coordinates
  crossings = 0

  @sides.each do |side|
    return true if lays_on_the_side?(side, coordinates)

    x_constraint, y_constraint = side

    if x_constraint.is_a?(Integer) && y_constraint.is_a?(Range)
      side_x = x_constraint
      y_min = y_constraint.begin
      y_max = y_constraint.end

      if px < side_x && py >= y_min && py < y_max
        crossings += 1
      end
    elsif x_constraint.is_a?(Range) && y_constraint.is_a?(Integer)
      next
    end
  end

  crossings.odd?
end

def cross_a_line_on_x?(x_range, y_const)
  inner_x = x_range.middle
  return false if inner_x.nil?

  @sides.any? do |x_constraint, y_constraint|
    next unless x_constraint.is_a?(Integer) && y_constraint.is_a?(Range)

    edge_x = x_constraint
    inner_y = y_constraint.middle
    next if inner_y.nil?

    inner_x.cover?(edge_x) && inner_y.cover?(y_const)
  end
end

def cross_a_line_on_y?(y_range, x_const)
  inner_y = y_range.middle
  return false if inner_y.nil?

  @sides.any? do |x_constraint, y_constraint|
    next unless x_constraint.is_a?(Range) && y_constraint.is_a?(Integer)

    inner_x = x_constraint.middle
    next if inner_x.nil?

    inner_y.cover?(y_constraint) && inner_x.cover?(x_const)
  end
end

def rectangle_inside?(point1, point2)
  x1, y1 = point1
  x2, y2 = point2

  x_min, x_max = [x1, x2].minmax
  y_min, y_max = [y1, y2].minmax

  corners = [
    [x_min, y_min],
    [x_min, y_max],
    [x_max, y_min],
    [x_max, y_max]
  ]

  x_line = (x_min..x_max)
  y_line = (y_min..y_max)

  # AB x_line,y_min
  # CD x_line,y_max
  # AC x_min,y_line
  # BD x_max,y_line


  return false if corners.any? { |c| !included_in_figure?(c) }
  return false if cross_a_line_on_x?(x_line,y_min)
  return false if cross_a_line_on_x?(x_line,y_max)
  return false if cross_a_line_on_y?(y_line,x_min)
  return false if cross_a_line_on_y?(y_line,x_max)

  true
end

n = @coordinates_list.length

@coordinates_list.each_with_index do |point1, i|
  ((i + 1)...n).each do |j|
    point2 = @coordinates_list[j]

    x_diff = (point1[0] - point2[0]).abs
    y_diff = (point1[1] - point2[1]).abs

    width  = x_diff + 1
    height = y_diff + 1
    area   = width * height

    next if area <= @biggest_area

    if rectangle_inside?(point1, point2)
      @biggest_area = area
    end
  end
end

puts "@biggest_area:#{@biggest_area}"