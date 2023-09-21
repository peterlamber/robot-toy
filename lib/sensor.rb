class Sensor
  def initialize(area)
    @mode = nil
    if area.size == 2
      set_rectangular_area(area)
    else
      #add other methods to scan for diferent kind of areas
    end
  end

  def valid_area?(position)
    if @mode == :rect
      (0..@rect.width).include?(position.x) && (0..@rect.height).include?(position.y)
    else
      #logic to scan other kind of areas
    end
  end

  private
  def set_rectangular_area(area)
    @mode = :rect 
    @rect = Rect.new(area[0], area[1])
  end
end