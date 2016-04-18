require_relative 'piece'

class Board
  attr_reader :grid

  LETTERS = {'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3,
             'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7,
  }

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def get_input_and_move
    begin
      puts "Move piece at ______ to position ______. e.g. f4,e2"
      print "> "

      start_and_end = split_input(gets.chomp)
      start_and_end.map! { |pos| translate_move_to_array_pos(pos) }
      start_pos, end_pos = start_and_end
      move(start_pos, end_pos)
    rescue => e
      puts e.message
      retry
    end
  end

  def split_input(str)
    start_and_end = str.strip.split(",")
    raise WrongNumOfArgs unless input.length == 2
    start_and_end
  end

  def translate_move_to_array_pos(pos_string)
    coordinates = pos_string.split("")
    raise NotABoardLetter unless LETTERS.keys.include?(coordinates.first)
    raise NotABoardNumber unless coordinates.last.between?(1,8)

    [LETTERS[coordinates.first], coordinates.last - 1]
  end

  def move(start_pos, end_pos)
    x, y = start_pos
    piece = @grid[x][y]
    raise NoPieceAtPosition if piece.nil?
    @grid[x][y] = nil
    x, y = end_pos
    @grid[x][y] = piece

  end

  def place_piece(pos)
    x, y = pos
    @grid[x][y] = Piece.new
  end
end
