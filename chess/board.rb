require_relative 'piece'
require_relative 'errors'

class Board
  attr_reader :grid

  # LETTERS = {'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3,
  #            'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7,
  # }

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.new } }
    place_piece([0,0])
  end

  # def get_input_and_move
  #   begin
  #     puts "Move piece at ______ to position ______. e.g. f4,e2"
  #     print "> "
  #
  #     start_and_end = split_input(gets.chomp.downcase)
  #     start_and_end.map! { |pos| translate_move_to_array_pos(pos) }
  #     start_pos, end_pos = start_and_end
  #     move(start_pos, end_pos)
  #   rescue => e
  #     puts e.message
  #     retry
  #   end
  # end
  #
  # def split_input(str)
  #   start_and_end = str.strip.split(",")
  #   raise WrongNumOfArgs unless start_and_end.length == 2
  #   start_and_end
  # end
  #
  # def translate_move_to_array_pos(pos_string)
  #   coordinates = pos_string.split("")
  #   raise NotABoardLetter unless LETTERS.keys.include?(coordinates.first)
  #   raise NotABoardNumber unless coordinates.last.between?(1,8)
  #
  #   [LETTERS[coordinates.first], coordinates.last - 1]
  # end

  def move(start_pos, end_pos)
    x, y = start_pos
    piece = @grid[x][y]
    raise NoPieceAtPosition if piece.is_a?(NullPiece)
    @grid[x][y] = NullPiece.new
    x, y = end_pos
    @grid[x][y] = piece

  end

  # def mark_start(pos)
  #   puts "Move this piece to WHERE??"
  #   # highlight piece (piece.change_piece_color)
  #
  # end
  #
  # def mark_end(pos)
  #   # change piece bolor back to how it were
  # end

  def place_piece(pos)
    x, y = pos
    @grid[x][y] = Pawn.new
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end
end
