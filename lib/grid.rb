module LDungeon
  class Grid
    attr_reader :cells

    def initialize(width,height,init_object)
      @init_object  = init_object
      @cells     = height.times.inject([]) do |lines,x|
                        lines << width.times.inject([]) { |line,x| line << init_object.clone }
                      end
    end

    def [](x,y)
      @cells[y][x]
    end

    def []=(x,y,value)
      @cells[y][x] = value
    end

    def width
      @cells.first.length
    end

    def height
      @cells.length
    end

    def fit(&vacant_discriminator)
      max_x, max_y = 0, 0
      min_x, min_y = width, height

      @cells.each.with_index do |line,y|
        line.each.with_index do |cell,x|
          unless vacant_discriminator.call(cell) then
            min_x = x if x < min_x
            min_y = y if y < min_y
            max_x = x if x > max_x
            max_y = y if y > max_y
          end
        end
      end

      @cells = @cells.slice min_y, max_y - min_y + 1
      @cells.map! { |line| line.slice min_x, max_x - min_x + 1 }

      [ min_x, min_y ]
    end

    def to_string(&vacant_discriminator)
      debug_string  = "- size: #{width}x#{height}\n-cells:\n"
      @cells.reverse.each do |line|
        debug_string += line.inject("  ") { |s,cell| s += ( vacant_discriminator.call(cell) ? "O" : "X" ) } + "\n"
      end

      debug_string
    end
  end
end
