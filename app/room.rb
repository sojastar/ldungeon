module LDungeon
  class Room
    attr_reader :types, :depth, :connections

    def initialize(base_type,depth=0)
      @types        = [base_type]
      @depth        = depth 
      @connections  = []
    end

    def self.vacant()
      Room.new(:vacant)
    end

    def is_vacant?
      @types.length == 1 && @types[0] == :vacant 
    end

    def is_start?
      @types.include? :start
    end

    def add_connection(connection)
      @connections << connection
      @connections.uniq!
    end

    def mix_with(other_room)
      @types        = ( @types + other_room.types ).uniq
      @types.delete(:empty)
      @depth        = [@depth, other_room.depth].max
      @connections += other_room.connections
    end

    def replace_with(other_room)
      @types        = other_room.types
      @depth        = other_room.depth#[@depth, other_room.depth].max
      @connections  = other_room.connections
    end

    def to_s
      "#{@types.inject('') { |list,type| list += type.to_s.capitalize.slice(0,2) }}"
    end

    def inspect
      to_s
    end
  end
end

