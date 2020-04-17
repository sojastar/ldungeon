module LDungeon
  class Connection
    attr_accessor :point1, :point2

    def initialize(point1,point2)
      @point1 = point1
      @point2 = point2
    end

    def ==(other)
      if @point1 == other.point1 && @point2 == other.point2 then
        true
      elsif @point1 == other.point2 && @point2 == other.point1 then
        true
      else
        false
      end
    end

    def offset_by(offset)
      @point1[0]  -= offset[0]
      @point1[1]  -= offset[1]
      @point2[0]  -= offset[0]
      @point2[1]  -= offset[1]
    end

    def to_s
      "from #{@point1[0]};#{@point1[1]} to #{@point2[0]};#{@point2[1]}"
    end
  end
end

