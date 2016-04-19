require_relative "display"
require_relative "board"

class Player
  def initialize(board)
    @display = Display.new(board)
  end

  def move
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
    result
  end
end


class Game
  attr_reader :current_player

  def initialize
    @board = Board.new
    @player = Player.new(@board)
    @current_player = :white
  end

  def run
    until @board.checkmate?
      begin
      set_current_player
      pos1 = @player.move
      pos2 = @player.move
      @board.move(pos1, pos2)
      switch_player
      rescue ChessError => e
        puts e.message
        sleep(2)
        retry
      end
    end
    switch_player
    puts "#{@current_player} wins!!!"
  end

  def switch_player
    @current_player == :white ? @current_player = :black : @current_player = :white
  end

  def set_current_player
    @board.current_player = @current_player
  end

end


if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
