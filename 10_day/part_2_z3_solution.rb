require "z3"

input_data = File.read(File.join(__dir__, "input.txt")).split("\n")

machines = []

input_data.each do |row|
  lights, buttons, powers =
    row.scan(/\[.*?\]|\(.*?\)|\{.*?\}/)
       .group_by { |m| m[0] }
       .transform_values { |vals|
         case vals.first[0]
         when "["
           vals.map { |v| v[1..-2] }
         when "("
           vals.map { |v| v[1..-2].split(",").map(&:to_i) }
         when "{"
           vals.first[1..-2].split(",").map(&:to_i)
         end
       }
       .values

  machines << { buttons: buttons, targets: powers }
end

def min_presses_for_machine(buttons, targets)
  solver = Z3::Optimize.new

  presses = buttons.each_index.map { |i| Z3.Int("press_#{i}") }

  presses.each do |p|
    solver.assert(p >= 0)
  end

  targets.each_with_index do |target, counter_idx|
    affecting = []

    buttons.each_with_index do |button, j|
      affecting << presses[j] if button.include?(counter_idx)
    end

    sum_expr = affecting.reduce(0) { |acc, var| acc + var }
    solver.assert(sum_expr == target)
  end

  total_expr = presses.reduce(0) { |acc, var| acc + var }
  solver.minimize(total_expr)

  solver.check

  model = solver.model

  press_values = presses.map { |p| model[p].to_i }
  total_presses = press_values.sum

  [total_presses, press_values]
end

total_presses_all = 0

machines.each_with_index do |machine, idx|
  min_presses, press_values =
    min_presses_for_machine(machine[:buttons], machine[:targets])

  total_presses_all += min_presses

  puts "Machine #{idx + 1}: min presses = #{min_presses}, per button = #{press_values.inspect}"
end

puts "Total presses (part 2): #{total_presses_all}"