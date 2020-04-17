require 'minitest/autorun'
require_relative 'test_helper.rb'

describe Array do
  it 'can add another array elementwise' do
    a1  = [0, 1, 2]
    a2  = [3, 4, 5]
    a3  = [6, 7]
    a4  = [8, 9, 10, 11]

    assert_equal  [3, 5, 7],    a1.add(a2)
    assert_equal  [6, 8],       a1.add(a3)
    assert_equal  [8, 10, 12],  a1.add(a4)
  end

  it 'can substract another array elementwise' do
    a1  = [0, 1, 2]
    a2  = [3, 4, 5]
    a3  = [6, 7]
    a4  = [8, 9, 10, 11]

    assert_equal  [-3, -3, -3], a1.sub(a2)
    assert_equal  [-6, -6],     a1.sub(a3)
    assert_equal  [-8, -8, -8], a1.sub(a4)
  end

  it 'can divide by a number elementwise' do
    a = [0, 1, 2]

    assert_equal  [0.0, 0.5, 1.0],  a.div(2)
  end
end

