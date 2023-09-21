class Movement
  def self.step(position)
    x, y, direction = position.x, position.y, position.direction

    case direction
      when 'NORTH'
        y += 1
      when 'SOUTH'
        y -= 1
      when 'EAST'
        x += 1
      when 'WEST'
        x -= 1
    end

    Position.new(x, y, direction)
  end

  def self.left(direction)
    case direction
      when 'NORTH'
        'WEST'
      when 'SOUTH'
        'EAST'
      when 'EAST'
        'NORTH'
      when 'WEST'
        'SOUTH'
    end
  end

  def self.right(direction)
    case direction
      when 'NORTH'
        'EAST'
      when 'SOUTH'
        'WEST'
      when 'EAST'
        'SOUTH'
      when 'WEST'
        'NORTH'
    end
  end
end