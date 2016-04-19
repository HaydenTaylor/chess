require "colorize"
require_relative "cursorable"

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
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :grey
    elsif (i + j).odd?
      bg = :light_black
    else
      bg = :light_white
    end
    { background: bg, color: :default }
  end

  def render
    system("clear")
    puts "Arrow keys to move, enter to confirm."
    build_grid.each { |row| puts row.join }
  end
end
