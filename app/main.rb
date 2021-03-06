require 'lib/extend_array.rb'
require 'lib/map.rb'
require 'lib/cell.rb'
require 'lib/connection.rb'
require 'lib/grid.rb'
require 'app/dungeon.rb'


### CONSTANTS :
MIN_ITERATIONS  = 1
MAX_ITERATIONS  = 3

GRID_MAX_SIZE   = [ 10, 10 ]

LOG_PATH        = 'generation_log.txt'





### SETUP :
def setup(args)

  # vvvvvvvvvvv GENERATING THE DUNGEON vvvvvvvvvvvvvvvvv #

  #dungeon_initial_state     = 'SececE'
  dungeon_initial_state     = 'ScE'
  #dungeon_generation_rules  = { 'S' => 'ceS',        
  dungeon_generation_rules  = { 'S' => 'Sec',        
                                #'c' => 'Peclpc' }
                                'c' => 'cPlpc' }
  args.state.iterations     = 1   # generation iteration count
  dungeon_layout_rules      = { 'e' => {  type: :empty,
                                          #mode: :mix  },
                                          mode: :discard  },
                                'c' => {  type: :challenge,
                                          #mode: :mix  },
                                          mode: :replace  },
                                'l' => {  type: :loot,
                                          mode: :mix  } }

  args.state.dungeon  = Dungeon.new dungeon_initial_state,
                                    dungeon_generation_rules,
                                    args.state.iterations,
                                    dungeon_layout_rules,
                                    GRID_MAX_SIZE

  # ^^^^^^^^^^^ GENERATING THE DUNGEON ^^^^^^^^^^^^^^^^^ #

  args.static_labels << [ 10, 720, "Press 'g' to regenerate the dungeon" ]
  args.static_labels << [ 10, 700, "Press 'd' to dump the dungeon generation log" ]

  args.state.setup_done = true
end





### MAIN LOOP :
def tick(args)
  ## Setup :
  setup(args) unless args.state.setup_done


  ## User Input :
  if args.inputs.keyboard.key_down.up then
    args.state.iterations += 1
    args.state.iterations = MAX_ITERATIONS if args.state.iterations >= MAX_ITERATIONS
  end

  if args.inputs.keyboard.key_down.down then
    args.state.iterations -= 1
    args.state.iterations = MIN_ITERATIONS if args.state.iterations <= MIN_ITERATIONS
  end

  if args.inputs.keyboard.key_down.g then
    args.state.dungeon.generate args.state.iterations, GRID_MAX_SIZE
  end

  if args.inputs.keyboard.key_down.d then
    log_file  = File.open(LOG_PATH, 'w+')
    log_file.write args.state.dungeon.generation_log.join("\n")
    log_file.close
  end


  ## Drawing stuff on screen :

  # vvvvvvvvvvv DRAWING THE DUNGEON vvvvvvvvvvvv #
  args.state.dungeon.draw(args, 100, 100, 30, 30)
  # ^^^^^^^^^^^ DRAWING THE DUNGEON ^^^^^^^^^^^^ #

  args.labels << [ 10, 680, "Press up or down to change the iteration count (#{args.state.iterations})" ]
  args.labels << [ 10, 660, "Dungeon l-string: #{args.state.dungeon.map.current_state}" ]
end
