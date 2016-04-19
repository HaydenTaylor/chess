require "colorize"
require_relative "cursorable"
require_relative "game"

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      if piece.is_a?(NullPiece)
        piece.to_s.colorize(color_options)
      else
        piece.to_s.colorize(
          { background: color_options[:background],
            color: piece.team }
          )
      end
      # piece.to_s.colorize(color_options)
    end

  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_cyan
      pce = :black
    elsif (i + j).odd?
      bg = :light_black
      pce = :white
    else
      bg = :light_white
      pce = :black
    end
    { background: bg, color: pce }
  end

  def render
    system("clear")
    puts "Arrow keys to move, enter to confirm."
    puts "Current player: #{@board.current_player}"
    build_grid.each { |row| puts row.join }
    puts "#{@board.in_check}'s king is in check!" if @board.in_check
  end
end
