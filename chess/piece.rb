require 'byebug'

class Piece
  attr_reader :team, :moves, :pos

  ORTHOGONALS = [[0,1], [0,-1], [1,0], [-1,0]]
  DIAGONALS = [[1,1], [1,-1], [-1,1], [-1,-1]]
  KNIGHT_MOVES = [
                  [1,2], [-1,2], [1,-2], [-1,-2],
                  [2,1], [-2,1], [2,-1], [-2,-1]
                  ]

  def initialize(pos, team, board)
    @pos = pos
    @team = team
    @board = board
  end

  def present?
    true
  end

  def to_s
    "xxx"
  end

  def moves
    board_dup = @board.deep_clone #NEED TO DEEP DUP THIS
    @moves.reject! do |move|
      if self.is_a?(Pawn)
        board_dup[move] = self.class.new(move, self.team, board_dup, self.direction, false)
      else
        board_dup[move] = self.class.new(move, self.team, board_dup)
      end
      board_dup.in_check?(team)
    end
  end
end

class NullPiece
  attr_reader :team

  def initialize
    @team = :null
  end

  def present?
    false
  end

  def to_s
    "   "
  end
end

#### PIECE SUBCLASSES

class SlidingPiece < Piece
  def generate_moves(moveset)
    moves = []
    moveset.each do |dir|
      8.times do |i|
        next if i == 0
        new_pos = [@pos[0] + i*dir[0], @pos[1] + i*dir[1]]
        next unless new_pos[0].between?(0,7) && new_pos[1].between?(0,7)
        unless @board[new_pos].class == NullPiece
          # debugger
          if self.team == @board[new_pos].team
            break
          elsif self.team != @board[new_pos].team
            moves << new_pos
            break
          end
        else
          moves << new_pos
        end
      end
    end

    moves
  end

end

class SteppingPiece < Piece
  def generate_moves(moveset)
    move_candidates = []
    moveset.each do |dir|
      new_pos = [@pos[0] + dir[0], @pos[1] + dir[1]]
      next unless new_pos.all? {|coordinate| coordinate.between?(0,7)}
      next if !@board[new_pos].is_a?(NullPiece) && @board[new_pos].team == self.team
      move_candidates << new_pos
    end

    move_candidates
  end
end

##### SLIDING PIECE SUBPIECES

class Rook < SlidingPiece
  def to_s
    # return " \u2656\a " if self.team == :white
    # " \u265C "
    " R "
  end

  def moves
    @moves = generate_moves(ORTHOGONALS)
  end
end


class Bishop < SlidingPiece
  def to_s
    # return " \u2657\a " if self.team == :white
    # " \u265D "
    " b "
  end

  def moves
    @moves = generate_moves(DIAGONALS)
    super
  end
end


class Queen < SlidingPiece
  def to_s
    # return " \u2655\a " if self.team == :white
    # " \u265B "
    " Q "
  end

  def moves
    @moves = generate_moves(ORTHOGONALS) + generate_moves(DIAGONALS)
    super
  end
end

### STEPPING PIECE SUBPIECES

class Knight < SteppingPiece

  def moves
    @moves = generate_moves(KNIGHT_MOVES)
    super
  end

  def to_s
    # return " \u2658\a " if self.team == :white
    # " \u265E "
    "kgt"
  end
end

class King < SteppingPiece
  def moves
    @moves = generate_moves(ORTHOGONALS) + generate_moves(DIAGONALS)
    super
  end

  def to_s
    # return " \u2654\a " if self.team == :white
    # " \u265A "
    " K "
  end

  def inspect
    "#{team} King"
  end
end

#### A SINGLE LONELY PAWN

class Pawn < Piece
  attr_reader :first_move, :direction


  def initialize(pos, team, board, first_move, direction)
    super(pos, team, board)
    @first_move = first_move
    @direction = direction
  end

  def moves
    candidate_moves = []
    @direction == :up ? multiplier = -1 : multiplier = 1

    # check if can move double on first move
    unless self.first_move == false
      one_space_away = [@pos[0] + multiplier, @pos[1] ]
      two_spaces_away = [@pos[0] + 2*multiplier, @pos[1]]
      if @first_move && @board[one_space_away].team == :null && @board[two_spaces_away].team == :null
        candidate_moves << [ @pos[0] + 2*multiplier, @pos[1]  ]
      end
    end

    # left enemy check
    new_pos = [@pos[0] + multiplier, @pos[1] - 1]
    piece_at_pos = @board[new_pos]
    if piece_at_pos
      if piece_at_pos.team != self.team && piece_at_pos.team != :null
        candidate_moves << new_pos
      end
    end

    # second corner enemy check
    new_pos = [@pos[0] + multiplier, @pos[1] + 1]
    piece_at_pos = @board[new_pos]
    if piece_at_pos
      if piece_at_pos.team != self.team && piece_at_pos.team != :null
        candidate_moves << new_pos
      end
    end

    # regular move
    new_pos = [@pos[0] + multiplier, @pos[1]]
    piece_at_pos = @board[new_pos]
    if piece_at_pos
      if piece_at_pos.team == :null
        candidate_moves << new_pos
      end
    end

    @moves = candidate_moves
    super
  end

  def to_s
    # return " \u2659\a " if self.team == :white
    # " \u265F "
    " p "
  end
end
