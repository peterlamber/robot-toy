require_relative "movement.rb"
require_relative "position.rb"
require_relative "geometry/rect.rb"
require_relative "brain.rb"
require_relative "sensor.rb"

class Robot
  def initialize(area = [4,4])
    print("beep beep..loading Brain\n")
    @brain = Brain.new(area)
    @position = nil
  end
  
  def input(data)
    parsed = @brain.parse(data)
    if @brain.input_valid?
      if parsed == :PLACE
        result = "Result: #{place(@brain.place_position)}"
      else
        result = "Result: #{send(parsed.downcase)}"
      end
      
    else
      result = @brain.error
    end

    print("#{result} \n")
    return result
  end

  private

  def place(destination)
    return false unless @brain.process_position(destination)
    set_position(destination)
    @brain.placed_successful

    true
  end

  def move
    destination = Movement.step(@position)
    return false unless @brain.process_position(destination)

    set_position(destination)    
    true
  end
  
  def left
    set_direction(Movement.left(@position.direction))
  end

  def right
    set_direction(Movement.right(@position.direction))
  end

  def report
    return false unless @position

    "#{@position.x},#{@position.y},#{@position.direction}"
  end

  def set_direction(direction)
    @position.direction = direction
  end

  def set_position(destination)
    @position = destination
  end
end
