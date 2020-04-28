require 'minitest/autorun'
require_relative 'test_helper.rb'

describe LDungeon::Grid do
  it 'initializes' do
    w = 5
    h = 4
    g = LDungeon::Grid.new w, h, LDungeon::Cell.vacant

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
    g = LDungeon::Grid.new 5, 4, LDungeon::Cell.vacant
    g[3,1] = LDungeon::Cell.new(:challenge, 4)

    assert_equal  [:challenge], g[3,1].types
    assert_equal  4,            g[3,1].depth
    assert_equal  [],           g[3,1].connections
  end

  it 'can refit itself around content that is not the init object' do
    g = LDungeon::Grid.new 11, 11, LDungeon::Cell.vacant
    g[4,3]  = c1  = LDungeon::Cell.new :start,      1
    g[3,4]  = c2  = LDungeon::Cell.new :challenge,  2
    g[5,4]  = c3  = LDungeon::Cell.new :loot,       3
    g[4,5]  = c4  = LDungeon::Cell.new :boss,       4

    g.fit { |cell| cell.is_vacant? }

    assert_equal  3,  g.width
    assert_equal  3,  g.height
    assert_equal  c1, g[1,0]
    assert_equal  c2, g[0,1]
    assert_equal  c3, g[2,1]
    assert_equal  c4, g[1,2]
  end
end

