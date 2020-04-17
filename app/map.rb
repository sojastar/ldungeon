module LDungeon
  class Map
    LEFT                        = [  1,  0 ]
    RIGHT                       = [ -1,  0 ]
    UP                          = [  0,  1 ]
    DOWN                        = [  0, -1 ]
    SURROUNDINGS                = [ LEFT, RIGHT, UP, DOWN ]
    NOT_EMPTY                   = [  0,  0 ]

    GENERATION_GRID_MAX_WIDTH   = 30
    GENERATION_GRID_MAX_HEIGHT  = 30

    attr_reader :current_state, :grid, :connections, :generation_log   # Debug !!!


    ### Initialization :
    def initialize(initial_state,generation_rules)
      @initial_state    = initial_state
      @generation_rules = generation_rules
      reset
    end

    def reset
      @current_state  = @initial_state
      @generation_log = []
      @grid           = Grid.new 100, 100, Room.vacant
      @connections    = []
    end


    ### L-System chain :
    def iterate_once
      new_state_words = @current_state.split('').collect do |word|
        @generation_rules.keys.include?(word) ? @generation_rules[word] : word
      end
      @current_state  = new_state_words.join

      @generation_log << "1 - iteration: " + @current_state
    end

    def iterate(n)
      n.times { iterate_once }
    end


    ### Layout :
    def room_at(coords)
      @grid[coords[0], coords[1]]
    end

    def find_vacant_surrounding(coords)
      SURROUNDINGS.shuffle.each do |direction|
        surrounding = coords.add direction
        if room_at(surrounding).is_vacant? then
          @generation_log << "2 --- in find_vacant_surrounding : found vacant space at #{surrounding}"
          return surrounding
        end
      end

      @generation_log << "2 --- in find_vacant_surrounding : no vacant space"
      NOT_EMPTY
    end

    def random_surrounding(coords)
      coords.add SURROUNDINGS.sample
    end

    def add_connection(connection)
      @connections << connection
      @connections.uniq!
    end

    def place_room(room,coords,mode=:discard)
      surrounding = find_vacant_surrounding(coords)

      if surrounding == NOT_EMPTY then
        surrounding = random_surrounding(coords)
        while room_at(surrounding).is_start? == true do
          surrounding = random_surrounding(coords)
        end

        case mode
        when :discard
          return coords
          @generation_log << "2 -- in place_room: discarded new room"
        when :mix
          room_at(surrounding).mix_with room
          @generation_log << "2 -- in place_room: mixed room at #{surrounding}"
        when :replace
          room_at(surrounding).replace_with room
          @generation_log << "2 -- in place_room: replaced room at #{surrounding}"
        end

      else
        # Place the new room :
        room_at(surrounding).replace_with room
        @generation_log << "2 -- in place_room: placed room at #{surrounding}"

        # Connect it with the previous room :
        connection  = Connection.new  coords.clone, surrounding.clone
        add_connection connection
        room_at(coords).add_connection connection
        room_at(surrounding).add_connection connection
        @generation_log << "2 -- in place_room: placed connection #{connection}"
      end

      surrounding
    end

    # possible modes: :discard  -> discard the room if there is no space for it and if it is...
    #                              ... not essential for the dungeon ( not start or boss )
    #                 :mix      -> if there is no space for the room to place, mix it with ...
    #                              ... one that is already there ( if not boss )
    #                 :replace  -> if there is no space for the room to place, replace the ...
    #                              ... previous one that is already there ( if not start or boss )
    def layout(mode=:discard)
      layout_state  = { stack:        [],
                        current_cell: [ @grid.width >> 2,
                                        @grid.height >> 2 ] }

      @current_state.split('').each do |word|
        case word
        when 'S'
          @generation_log << "2 - in layout - START room from #{layout_state[:current_cell]}, stack depth #{layout_state[:stack].length}"
          layout_state[:current_cell] = place_room  Room.new( :start, layout_state[:stack].length),
                                                    layout_state[:current_cell],
                                                    :replace
        when 'E'
          @generation_log << "2 - in layout - EMPTY room from #{layout_state[:current_cell]}, stack depth #{layout_state[:stack].length}"
          layout_state[:current_cell] = place_room  Room.new(:empty, layout_state[:stack].length),
                                                    layout_state[:current_cell],
                                                    mode
        when 'C'
          @generation_log << "2 - in layout - CHALLENGE room from #{layout_state[:current_cell]}, stack depth #{layout_state[:stack].length}"
          layout_state[:current_cell] = place_room  Room.new(:challenge, layout_state[:stack].length),
                                                    layout_state[:current_cell],
                                                    mode
        when 'L'
          @generation_log << "2 - in layout - LOOT room from #{layout_state[:current_cell]}, stack depth #{layout_state[:stack].length}"
          layout_state[:current_cell] = place_room  Room.new(:loot, layout_state[:stack].length),
                                                    layout_state[:current_cell],
                                                    mode
        when 'B'
          @generation_log << "2 - in layout - BOSS room from #{layout_state[:current_cell]}, stack depth #{layout_state[:stack].length}"
          layout_state[:current_cell] = place_room  Room.new(:boss, layout_state[:stack].length),
                                                    layout_state[:current_cell],
                                                    :replace
        when 'P'
          @generation_log << "2 - in layout - PUSH from #{layout_state[:current_cell]}, stack depth #{layout_state[:stack].length}"
          layout_state[:stack] << layout_state[:current_cell]
        when 'p'
          @generation_log << "2 - in layout - POP from #{layout_state[:current_cell]}, stack depth #{layout_state[:stack].length}"
          layout_state[:current_cell] = layout_state[:stack].pop
        else
          @generation_log << "2 - unknown layout char #{word}"
        end
      end

      # Clean-up
      offset = @grid.fit { |cell| cell.is_vacant? }

      @connections.shift
      @connections.each.with_index { |connection,i| connection.offset_by offset }
    end
  end
end

