module LDungeon
  class Grid
    def initialize(width,height,init_object)
      @init_object  = init_object
      @elements     = height.times.inject([]) do |lines,i|
                        lines << width.times.inject([]) { |new_line,j| new_line << init_object.clone }
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

    def fit
            
    end
  end
end
