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
  def initialize
    @board = Board.new
    @player = Player.new(@board)
  end

  def run
    puts "Mark all the spaces on the board!"
    puts "Arrow keys to move the cursor, enter to confirm."
    while true
      begin
      pos1 = @player.move
      pos2 = @player.move
      @board.move(pos1, pos2)
      rescue => e
        puts e.message
        sleep(2)
        retry
      end
    end
    puts "Hooray, the board is filled!"
  end
end


if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
