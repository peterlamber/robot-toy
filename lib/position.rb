class Position # should be named better, can't think of anything else 
  attr_accessor :x, :y, :direction
  def initialize(x, y, direction)
    @x, @y, @direction = x, y, direction
  end
end