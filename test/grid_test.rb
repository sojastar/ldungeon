require 'minitest/autorun'
require_relative 'test_helper.rb'

describe LDungeon::Grid do
  it 'initializes' do
    w = 5
    h = 4
    g = LDungeon::Grid.new w, h, LDungeon::Room.vacant

    assert_equal  w, g.width
    assert_equal  h, g.height 

    h.times do |y|
      w.times do |x|
        assert_equal  [:vacant],  g[x,y].types
        assert_equal  0,          g[x,y].depth
        assert_equal  [],         g[x,y].connections
      end
    end

    refute  g[0,0].object_id == g[1,0].object_id
  end

  it 'can access an element by its coordinates' do
    g = LDungeon::Grid.new 5, 4, LDungeon::Room.vacant
    g[3,1] = LDungeon::Room.new(:challenge, 4)

    assert_equal  [:challenge], g[3,1].types
    assert_equal  4,            g[3,1].depth
    assert_equal  [],           g[3,1].connections
  end

  it 'can refit itself around content that is not the init object' do
  end
end

