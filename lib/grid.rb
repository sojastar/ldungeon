module LDungeon
  class Grid
    MAX_XY  = 4611686018427387903 
    MIN_XY  = -MAX_XY - 1
    def initialize(width,height,init_object)
      @init_object  = init_object
      @elements     = height.times.inject([]) do |lines,x|
                        lines << width.times.inject([]) { |line,x| line << init_object.clone }
                      end
    end

    def [](x,y)
      @elements[y][x]
    end

    def []=(x,y,value)
      @elements[y][x] = value
    end

    def width
      @elements.first.length
    end

    def height
      @elements.length
    end

    def fit(&vacant_discriminator)
      max_x, max_y = MIN_XY, MIN_XY
      min_x, min_y = MAX_XY, MAX_XY

      @elements.each.with_index do |line,y|
        line.each.with_index do |element,x|
          unless vacant_discriminator.call(element) then
            min_x = x if x < min_x
            min_y = y if y < min_y
            max_x = x if x > max_x
            max_y = y if y > max_y
          end
        end
      end

      @elements = @elements.slice min_y, max_y - min_y + 1
      @elements.map! { |line| line.slice min_x, max_x - min_x + 1 }

      [min_x,min_y]
    end
  end
end
