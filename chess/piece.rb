class Piece
  attr_reader :color

  def present?
    true
  end

  def to_s
    "xx"
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

class SteppingPiece < Piece
end



class Pawn < Piece
  attr_reader :color

  def initialize
    super
    @color = :red
  end

  def to_s
    "pn"
  end
end
