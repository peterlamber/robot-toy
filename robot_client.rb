require_relative "lib/robot.rb"

robot = Robot.new

File.open('input.txt', 'r') do |data|
  data.each_line do |command|
    robot.input(command)
  end
end