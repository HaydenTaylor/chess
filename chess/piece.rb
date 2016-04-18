class Piece
  attr_reader :color

  def initialize(pos)
    @pos = pos
  end

  def present?
    true
  end

  def to_s
    "xx"
  end

  def moves
  end

end

class NullPiece
  def present?
    false
  end

  def to_s
    "  "
  end
end


class SlidingPiece < Piece
end

class Rook < SlidingPiece
  def moves
    @moves = []
    7.times do |i|
      next if @pos == [ @pos[0], i ]
      @moves << [ @pos[0],i ]
    end
    7.times do |j|
      next if @pos == [ j, @pos[1] ]
      @moves << [ j, @pos[1] ]
    end
    moves
  end
  
end




class SteppingPiece < Piece
end



class Pawn < Piece
  attr_reader :color

  def initialize(pos)
    super
    @color = :red
  end

  def to_s
    "pn"
  end
end
