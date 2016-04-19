require_relative 'board'

class Piece
  attr_reader :team

  ORTHOGONALS = [[0,1], [0,-1], [1,0], [-1,0]]
  DIAGONALS = [[1,1], [1,-1], [-1,1], [-1,-1]]
  # TEAM = {:white => "white",
  #         :black => "black"}

  def initialize(pos, team, board)
    @pos = pos
    @team = team
    @board = board
  end

  def present?
    true
  end

  def to_s
    "xx"
  end

  def moves
    @moves
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
  def generate_moves(moveset)
    moveset.each do |dir|
      8.times do |i|
        new_pos = [@pos[0] + dir[0], @pos[1] + dir[1]]
        next unless new_pos[0].between?(0,7) && new_pos[1].between?(0,7)
        unless @board[new_pos].class == NullPiece
          if self.team == @board[new_pos].team
            break
          elsif
            self.team != @board[new_pos].team
            moves << new_pos
            break
          end
        else
          moves << new_pos
        end
      end

      moves
    end
  end
  #
  #
  #
  #
  #   8.times do |i|
  #     next if @pos == [ @pos[0], i ]
  #     moves << [ @pos[0], i ]
  #     unless @board[@pos[0],i].class == NullPiece
  #       if self.team == @board[@pos[0],i].team
  #         return moves[0...-1]
  #       elsif self.team != @board[@pos[0],i]].team
  #         return moves
  #       end
  #     end
  #   end
  #
  #   moves
  # end
  #
  # def horizontal_moves
  #   moves = []
  #   8.times do |j|
  #     next if @pos == [ j, @pos[1] ]
  #     moves << [ j, @pos[1] ]
  #   end
  #
  #   moves
  # end
  #
  #
  # def diagonal_moves
  #   up_right_diags + up_left_diags + down_right_diags + down_left_diags
  # end
  #
  # def up_right_diags
  #   moves = []
  #   8.times do |i|
  #     next if (@pos[0] + i) > 8 || (@pos[1] - i) < 0
  #     moves << [ @pos[0] + i , @pos[1] - i ]
  #   end
  #
  #   8.times do |i|
  #     next if (@pos[0] - i) < 0 || (@pos[1] + i) > 8
  #     moves << [ @pos[0] - i , @pos[1] + i ]
  #   end
  #
  #   moves
  # end
end

class Rook < SlidingPiece
  def to_s
    "RK"
  end

  def moves
    @moves = generate_moves(ORTHOGONALS)
  end
end

class Bishop < SlidingPiece
  def to_s
    "&&"
  end

  def moves
    @moves = generate_moves(DIAGONALS)
  end
end

class Queen < SlidingPiece
  def to_s
    "{}"
  end

  def moves
    @moves = generate_moves(ORTHOGONALS) + generate_moves(DIAGONALS)
  end
end


class SteppingPiece < Piece
end

class Knight < SteppingPiece
  def to_s
    "KN"
  end
end

class King < SteppingPiece
  def to_s
    "<>"
  end
end


class Pawn < Piece
  def to_s
    "pn"
  end
end
