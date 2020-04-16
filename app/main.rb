require 'app/extend_array.rb'
require 'app/map.rb'
require 'app/room.rb'
require 'app/connection.rb'


### CONSTANTS :
LOG_PATH  = 'generation_log.txt'

### SETUP :
def generate_dungeon
  dungeon = LDungeon::Map.new(  'SECECB',
                                { 'S'  => 'CES',
                                  #'E'  => 'PECLpC' } )
                                  'C'  => 'PECLpC' } )
  dungeon.iterate 2
  dungeon.layout :mix

  dungeon
end

def setup(args)
  args.state.dungeon    = generate_dungeon

  args.static_labels << [ 10, 720, "Press 'g' to regenerate the dungeon" ]
  args.static_labels << [ 10, 700, "Press 'd' to dump the dungeon generation log" ]

  args.state.setup_done = true
end


### DRAWING :
def draw_room(room,x,y,cell_width,cell_height)
  cell          = [ x, y, cell_width, cell_height ]
  cell_outline  = cell + [ 0, 0, 0, 255 ]
  color         = case
                  when room.types.include?(:start)  then  [ 255, 255,   0, 255 ]
                  when room.types.include?(:boss)   then  [ 255,   0, 255, 255 ]
                  else                              case room.depth
                                                    when 0  then  [   0, 255,   0, 255 ]
                                                    when 1  then  [   0,   0, 255, 255 ]
                                                    else          [ 255,   0,   0, 255 ]
                                                    end
                  end
  cell_fill     = cell + color
  label         = [ x + 5,
                    y + cell_height - 5,
                    "#{room.types.inject('') { |list,type| list += type.to_s.capitalize.slice(0,2) }}", -5 ]
  
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

def draw_dungeon(args,base_x,base_y,cell_width,cell_height)
  # Drawing rooms :
  grid  = args.state.dungeon.grid
  grid.length.times do |y|
    grid[y].length.times do |x|
      unless grid[y][x].is_vacant? then
        cell_outline, cell_fill, label  = draw_room grid[y][x],
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
  args.state.dungeon.connections.each do |connection|
    args.solids << draw_connection( connection,
                                    base_x,
                                    base_y,
                                    cell_width,
                                    cell_height )
  end
end


### MAIN LOOP :
def tick(args)
  ## Setup :
  setup(args) unless args.state.setup_done

  ## Drawing the Dungeon :
  draw_dungeon(args, 100, 100, 30, 30)
  args.labels << [ 10, 680, "Dungeon l-string: #{args.state.dungeon.current_state}" ]

  ## User Input :
  if args.inputs.keyboard.key_down.g then
    args.state.dungeon = generate_dungeon
  end

  if args.inputs.keyboard.key_down.d then
    log_file  = File.open(LOG_PATH, 'w+')
    log_file.write args.state.dungeon.generation_log.join("\n")
    log_file.close
  end
end
