class ChessError < StandardError
end

class NotYourPiece < ChessError
  def message
    "Get your hands off the other guy's piece!"
  end
end

class InvalidMove < ChessError
  def message
    "You can't move that piece there!"
  end
end

class KingInCheck < ChessError
  def message
    "This move puts the enemy king in check!"
  end
end

class NoPieceAtPosition < ChessError
  def message
    "There's no piece at the position you entered."
  end
end
