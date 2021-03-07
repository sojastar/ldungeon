require 'minitest/autorun'
require_relative 'test_helper.rb'

describe LDungeon::Cell do
  it 'initializes' do
    r = LDungeon::Cell.new :start, 3

    assert_equal  [:start], r.types
    assert_equal  3,        r.depth
    assert_equal  [],       r.connections
  end

  it 'can create a vacant room/space' do
    v = LDungeon::Cell.vacant

    assert_equal  [:vacant],  v.types
    assert_equal  0,          v.depth
    assert_equal  [],         v.connections
  end

  it 'can test wether a room/space is vacant' do
    v = LDungeon::Cell.vacant
    s = LDungeon::Cell.new :start, 3

    assert  v.is_vacant?
    refute  s.is_vacant?
  end

  it 'can test wether a room is the start room or not' do
    s = LDungeon::Cell.new :start, 3
    s.types << :loot
    e = LDungeon::Cell.new :empty, 1

    assert  s.is_start?
    refute  e.is_start?
  end

  it 'can add connections' do
    r = LDungeon::Cell.new :loot, 2
    r.add_connection LDungeon::Connection.new([0, 1], [2, 3])
    r.add_connection LDungeon::Connection.new([4, 5], [6, 7])

    assert_equal  2, r.connections.length
  end

  it 'can mix with another room' do
    r1  = LDungeon::Cell.new :challenge,  1
    c11 = LDungeon::Connection.new([0, 1], [2, 3])
    c12 = LDungeon::Connection.new([4, 5], [6, 7])
    r1.add_connection c11
    r1.add_connection c12

    r2  = LDungeon::Cell.new :loot,       3
    c21 = LDungeon::Connection.new([10, 21], [32, 43])
    c22 = LDungeon::Connection.new([14, 25], [36, 47])
    r2.add_connection c21
    r2.add_connection c22

    r1.mix_with r2

    assert_equal  [:challenge, :loot],  r1.types
    assert_equal  3,                    r1.depth
    assert_equal  4,        r1.connections.length
    assert        r1.connections.include? c11
    assert        r1.connections.include? c12
    assert        r1.connections.include? c21
    assert        r1.connections.include? c22
  end

  it 'can be replaced with another room' do
    r1  = LDungeon::Cell.new :challenge,  1
    c11 = LDungeon::Connection.new([0, 1], [2, 3])
    c12 = LDungeon::Connection.new([4, 5], [6, 7])
    r1.add_connection c11
    r1.add_connection c12

    r2  = LDungeon::Cell.new :loot,       3
    c21 = LDungeon::Connection.new([10, 21], [32, 43])
    c22 = LDungeon::Connection.new([14, 25], [36, 47])
    r2.add_connection c21
    r2.add_connection c22

    r1.replace_with r2

    assert_equal  [:loot],  r1.types
    assert_equal  3,        r1.depth
    assert_equal  2,        r1.connections.length
    assert        r1.connections.include? c21
    assert        r1.connections.include? c22
  end
end

