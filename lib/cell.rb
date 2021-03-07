module LDungeon
  class Cell
    attr_reader :types, :depth, :connections

    def initialize(base_type,depth=0)
      @types        = [base_type]
      @depth        = depth 
      @connections  = []
    end

    def self.vacant()
      Cell.new(:vacant)
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

    def mix_with(other_cell)
      @types        = ( @types + other_cell.types ).uniq
      @types.delete(:empty)
      @depth        = [@depth, other_cell.depth].max
      @connections += other_cell.connections
      puts "---- in Connection#mix_with: #{@connections}"
    end

    def replace_with(other_cell)
      @types        = other_cell.types
      @depth        = other_cell.depth
      @connections  = other_cell.connections
    end

    def to_s
      "#{@types.inject('') { |list,type| list += type.to_s.capitalize.slice(0,2) }}"
    end

    def inspect
      to_s
    end
  end
end

