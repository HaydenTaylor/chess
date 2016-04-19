require_relative 'piece'
require_relative 'errors'
require 'byebug'

class Board
  attr_reader :grid, :in_check
  attr_accessor :current_player

  # LETTERS = {'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3,
  #            'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7,
  # }

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.new } }
    @in_check = false
    set_up_grid
  end

  def place_row_pawns(row, color, direction)
    places = [[row,0], [row,1], [row,2], [row,3], [row,4], [row,5], [row,6], [row,7]]
    places.each do |place|
      x,y = place
      @grid[x][y] = Pawn.new(place, color, self, true, direction)
    end
  end

  def place_other_pieces(row, color)
    places = [[row,0], [row,1], [row,2], [row,3], [row,4], [row,5], [row,6], [row,7]]
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    pieces.each do |piece|
      x, y = places.shift
      @grid[x][y] = piece.new([x, y], color, self)
    end
  end

  def set_up_grid
    place_other_pieces(0, :white)
    place_row_pawns(1, :white, :down)
    place_row_pawns(6, :black, :up)
    place_other_pieces(7, :black)
  end


  def move(start_pos, end_pos)
    x, y = start_pos
    w, z = end_pos
    piece = @grid[x][y]

    raise NotYourPiece if piece.team != @current_player
    raise NoPieceAtPosition if piece.is_a?(NullPiece)
    raise InvalidMove unless piece.moves.include?(end_pos)

    # debugger
    if piece.is_a?(Pawn)
      @grid[w][z] = Pawn.new(end_pos, piece.team, self, false, piece.direction)
    else
      @grid[w][z] = piece.class.new(end_pos, piece.team, self)
    end
    @grid[x][y] = NullPiece.new

    piece.team == :white ? enemy_color = :black : enemy_color = :white
    if in_check?(enemy_color)
      @in_check = enemy_color
    else
      @in_check = false
    end
  end

  def in_check?(color)
    color == :white ? opposite_color = :black : opposite_color = :white
    king_position = nil
    enemy_moves = []
    # debugger
    @grid.flatten.each do |piece|
      # debugger if piece.nil?
      if piece.is_a?(King) && piece.team == color
        king_position = piece.pos
      elsif piece.team == opposite_color
        enemy_moves += piece.moves
      end
    end

    enemy_moves.include?(king_position)
  end

  def checkmate?
    return true if @in_check && valid_moves.empty?
    false
  end

  def valid_moves
    moves = []

    @grid.flatten.each do |piece|
      if piece.team == @current_player
        moves += piece.moves
      end
    end

    moves
  end

  def dup
    #write this
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def rows
    @grid
  end
end
