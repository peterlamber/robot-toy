class Brain
  VALID_COMMANDS = %w{PLACE MOVE LEFT RIGHT REPORT}
  DIRECTION_MAP = {"N": "NORTH", "E": "EAST", "W": "WEST", "S": "SOUTH"}

  attr_reader :place_position, :error

  def initialize(area)
    @host_placed = false
    @sensors = Sensor.new(area)
    @place_position = nil
    @error = nil
    print("Brain loaded\n")
  end

  def parse(input)
    flush_error
    print("Processing command: #{input.strip}\n")
    
    # regex pattern to match any valid command
    command_pattern = /\b(?:#{Regexp.union(VALID_COMMANDS)})\b/
    match = input.match(command_pattern)

    return set_error("Error: Unrecognized Command.") unless match
    
    command = match[0].to_sym

    if command == :PLACE
      @place_position = place(input)
      return unless input_valid?
      flush_error
      return command
    end

    if @host_placed
      flush_error
      return command
    end 
  
    set_error("Error: Issue PLACE command first to continue.")
  end
  
  def process_position(destination)
    @sensors.valid_area?(destination)
  end

  def input_valid?
    @error.nil?
  end

  def placed_successful
    @host_placed = true
  end
  
  private

  def place(input)
    # regex to gather PLACE params
    params = input.match(/(\(.*\))/ )[0][1..-2].split(",")
    return unless params_valid?(params)
    
    Position.new( params[0].to_i, params[1].to_i, DIRECTION_MAP[params[2].to_sym])
  end
  
  def params_valid?(params)
    return set_error("Too many PLACE Parameters. Try something like 1,2,E") if params.size > 3
    #todo more sanity checking input params
    true
  end
  
  def set_error(msg)
    @error = msg
    false
  end

  def flush_error
    @error = nil
  end
end