class Dungeon
  include LDungeon

  attr_accessor :map

  def initialize(initial_state,generation_rules,iterations,layout_rules)
    @map  = Map.new initial_state, generation_rules, layout_rules
    generate(iterations)
  end

  def generate(iterations)
    @map.reset
    @map.iterate iterations
    @map.layout   
  end

  def generation_log
    @map.generation_log
  end
  
  def draw(args,base_x,base_y,cell_width,cell_height)
    # Drawing room/cells :
    grid  = @map.grid
    grid.height.times do |y|
      grid.width.times do |x|
        unless grid[x,y].is_vacant? then
          cell_outline, cell_fill, label  = draw_cell grid[x,y],
                                                      base_x + x * cell_width,
                                                      base_y + y * cell_height,
                                                      cell_width,
                                                      cell_height
          args.borders  << cell_outline
          args.solids   << cell_fill
          args.labels   << label
        end
      end
    end
  
    # Drawing connections :
    @map.connections.each do |connection|
      args.solids << draw_connection( connection,
                                      base_x,
                                      base_y,
                                      cell_width,
                                      cell_height )
    end
  end

  def draw_cell(cell,x,y,cell_width,cell_height)
    cell_geometry = [ x, y, cell_width, cell_height ]
    cell_outline  = cell_geometry + [ 0, 0, 0, 255 ]
    color         = case
                    when cell.types.include?(:start)  then  [ 255, 255,   0, 255 ]
                    when cell.types.include?(:boss)   then  [ 255,   0, 255, 255 ]
                    else                                    case cell.depth
                                                            when 0  then  [   0, 255,   0, 255 ]
                                                            when 1  then  [   0,   0, 255, 255 ]
                                                            else          [ 255,   0,   0, 255 ]
                                                            end
                    end
    cell_fill     = cell_geometry + color
    label         = [ x + 5,
                      y + cell_height - 5,
                      "#{cell.types.inject('') { |list,type| list += type.to_s.capitalize.slice(0,2) }}", -5 ]
    
    [cell_outline, cell_fill, label] 
  end
  
  def draw_connection(connection,base_x,base_y,cell_width,cell_height)
    center1 = [ base_x + cell_width  * ( connection.point1[0] + 0.5 ), 
                base_y + cell_height * ( connection.point1[1] + 0.5 ) ]
    center2 = [ base_x + cell_width  * ( connection.point2[0] + 0.5 ), 
                base_y + cell_height * ( connection.point2[1] + 0.5 ) ]
    center  = center1.add(center2).div(2)
  
    [ center[0] - 3, center[1] - 3, 6, 6, 0, 0, 0, 255 ]
  end
end

