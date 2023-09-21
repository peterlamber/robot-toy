require_relative '../lib/robot'
require_relative '../lib/sensor'
require_relative '../lib/movement'
require_relative '../lib/position'

describe Robot do
  let(:robot) {Robot.new}
  describe "#place" do
    it "returns true if valid placement" do
      position = Position.new(1, 2, 'NORTH')
      expect(robot.send(:place, position)).to eq(true)
    end

    it "returns false if invalid placement" do
      position = Position.new(1, 5, 'NORTH')
      expect(robot.send(:place, position)).to eq(false)
    end
  end

  describe "#move" do
    it "returns true if valid move" do
      position = Position.new(1, 2, 'NORTH')
      expect(robot.send(:place, position)).to eq(true)

      expect(robot.send(:move)).to eq(true)
    end

    it "returns false if invalid move" do
      position = Position.new(1, 4, 'NORTH')
      expect(robot.send(:place, position)).to eq(true)

      expect(robot.send(:move)).to eq(false)
    end
    # etc, check other directions
  end
  
  describe "#left" do
    it "returns WEST if direction is NORTH" do
      expect(Movement.left("NORTH")).to eq "WEST"
    end

    it "returns SOUTH if direction is WEST" do
      expect(Movement.left("WEST")).to eq "SOUTH"
    end
    # etc, check other directions
  end
  
  describe "#right" do
    it "returns WEST if direction is NORTH" do
      expect(Movement.right("NORTH")).to eq "EAST"
    end
    #same jazz but the other way
  end
  
  describe "#report" do
    it "returns correct report" do
      position = Position.new(1, 2, 'NORTH')
      expect(robot.send(:place, position)).to eq(true)

      expect(robot.send(:report)).to eq("1,2,NORTH")
    end

    it "returns false if unable to report" do
      expect(robot.send(:report)).to eq(false)
    end
  end

  describe "place and turn and move" do
    it "should report the correct position(1,4,WEST) at the end" do 
      robot.input("PLACE(1,1,N)")
      robot.input("MOVE")
      robot.input("MOVE")
      robot.input("MOVE")
      robot.input("RIGHT")
      robot.input("RIGHT")
      robot.input("RIGHT")
      expect(robot.send(:report)).to eq("1,4,WEST")
    end

    it "should not fall of the table" do
      robot.input("PLACE(0,0,N)")
      robot.input("LEFT")
      robot.input("MOVE")
      robot.input("MOVE")
      expect(robot.send(:report)).to eq("0,0,WEST")
      robot.input("PLACE(5,10,N)")
      expect(robot.send(:report)).to eq("0,0,WEST")
      robot.input("RIGHT")
      robot.input("MOVE")
      expect(robot.send(:report)).to eq("0,1,NORTH")
    end
  end

  describe "forget to place and try to do something" do
    it "should not let you do anything" do
      robot.input("LEFT")
      robot.input("MOVE")
      robot.input("RIGHT")
      robot.input("MOVE")
      expect(robot.send(:report)).to eq(false)
    end

    it "should not deadlock if placing comes after some failed commands" do
      robot.input("LEFT")
      robot.input("MOVE")
      robot.input("PLACE(2,3,N)")
      robot.input("RIGHT")
      robot.input("MOVE")
      expect(robot.send(:report)).to eq("3,3,EAST")
    end
  end

  describe "invalid input" do 
    it "should disregard invalid input but allow further valid commands" do
      expect(robot.input("LEFTE")[0]).to eq("Error: Unrecognized Command.")
      expect(robot.input("PLACE(2,3,4,N)").include?("Too many PLACE Parameters. Try something like 1,2,E")).to eq(true)
      robot.input("PLACE(2,3,N)")
      expect(robot.send(:report)).to eq("2,3,NORTH")
    end
  end
end
