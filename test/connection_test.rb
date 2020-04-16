require 'minitest/autorun'
require_relative 'test_helper.rb'

describe LDungeon::Connection do
  it 'initializes' do
    c = LDungeon::Connection.new [0, 1], [2, 3]

    assert_equal  [0, 1],  c.point1
    assert_equal  [2, 3],  c.point2
  end

  it 'can check for equality wether both points are reversed or not' do
    c1  = LDungeon::Connection.new [0, 1], [2, 3]
    c2  = LDungeon::Connection.new [2, 3], [0, 1]
    c3  = LDungeon::Connection.new [0, 1], [4, 3]

    assert  c1 == c2
    refute  c1 == c3
  end
end

