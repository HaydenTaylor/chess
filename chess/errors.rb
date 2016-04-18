class WrongNumOfArgs < StandardError
  def message
    "Game requires two positions. Format: a2,b5"
  end
end

class NotABoardLetter < StandardError
  def message
    "One or more row letter you gave does not belong on standard chess board (a-h)"
  end
end

class NotABoardNumber < StandardError
  def message
    "One or more column numbers you gave does not belong on a standard chess board (1-8)"
  end
end

class NoPieceAtPosition < StandardError
  def message
    "There's no piece at the position you entered."
  end
end
