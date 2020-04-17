class Array
  def add(other)
    sum = []
    [length, other.length].min.times { |i| sum << at(i) + other.at(i) }
    sum
  end

  def sub(other)
    dif = []
    [length, other.length].min.times { |i| dif << at(i) - other.at(i) }
    dif
  end

  def div(f)
    f = f.to_f
    map { |e| e / f }
  end
end

