@input_data = File.read(File.dirname(__FILE__) + '/input.txt').split("\n")

@lights  = []
@buttons = []
@powers  = []

@total_presses = 0

@input_data.each do |row|
  lights, buttons, powers =
    row.scan(/\[.*?\]|\(.*?\)|\{.*?\}/)
       .group_by { |m| m[0] }
       .transform_values { |vals|
         case vals.first[0]
         when "[" then vals.map { |v| v[1..-2] }
         when "(" then vals.map { |v| v[1..-2].split(",").map(&:to_i) }
         when "{" then vals.first[1..-2].split(",").map(&:to_i)
         end
       }
       .values

  @lights  << lights[0].chars.map{|el| el == '#' }
  @buttons << buttons
  @powers  << powers
end

def press_button(current_lights,changing_lights_from_button)
  current_lights = current_lights.dup
  changing_lights_from_button.map do |light|
    current_lights[light] = !current_lights[light]
  end

  current_lights
end

def calculate_shortest_amount_of_presses(target,buttons)
  empty_lights = target.map{false}
  current_lights = empty_lights
  current_state = [[]]
  current_state[0] << [empty_lights,[]]
  current_amount_of_presses = 0

  loop do
    next_press = current_amount_of_presses+1
    key_exist = false
    current_state[current_amount_of_presses].each do |new_lights,last_pressed|
      buttons.reject{|button| button == last_pressed}.each do |button|
        current_lights = press_button(new_lights, button)
        return next_press if current_lights == target
        if key_exist
          current_state[next_press] << [current_lights,buttons.index(button)]
        else
          current_state[next_press] = [[current_lights,buttons.index(button)]]
          key_exist = true
        end
      end
    end
    current_amount_of_presses = next_press
  end
end

@buttons.each_with_index do |buttons, index|
  target_lights = @lights[index]
  @total_presses += calculate_shortest_amount_of_presses(target_lights,buttons)
end

puts "@total_presses:#{@total_presses}"