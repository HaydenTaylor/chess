require_relative "board"
require_relative "player"


class NotArrayError < StandardError
  def message
    "input must be of type Array"
  end
end

class WrongNumberOfArguments < StandardError
  def message
    "just two numbers, separated by a comma, dummy!"
  end
end

class NotOnBoard < StandardError
  def message
    "one or more of your coordinates is outside of board range"
  end
end


class MemoryGame
  attr_reader :player

  def initialize(player, size = 4)
    @board = Board.new(size)
    @previous_guess = nil
    @player = player
  end

  def compare_guess(new_guess)
    if previous_guess
      if match?(previous_guess, new_guess)
        player.receive_match(previous_guess, new_guess)
      else
        puts "Try again."
        [previous_guess, new_guess].each { |pos| board.hide(pos) }
      end
      self.previous_guess = nil
      player.previous_guess = nil
    else
      self.previous_guess = new_guess
      player.previous_guess = new_guess
    end
  end

  def get_player_input
    pos = nil

    begin
      pos = player.get_input
      valid_pos?(pos)
    rescue => e
      puts e.message
      puts "Valid input should be in form: x,y where both are on board"
      retry
    end

    until pos && valid_pos?(pos)
      pos = player.get_input
    end

    pos
  end

  def make_guess(pos)
    revealed_value = board.reveal(pos)
    player.receive_revealed_card(pos, revealed_value)
    board.render

    compare_guess(pos)

    sleep(1)
    board.render
  end

  def match?(pos1, pos2)
    board[pos1] == board[pos2]
  end

  def play
    until board.won?
      board.render
      pos = get_player_input
      make_guess(pos)
    end

    puts "Congratulations, you win!"
  end

  def valid_pos?(pos)

    raise NotArrayError unless pos.is_a?(Array)
    raise WrongNumberOfArguments unless pos.count == 2
    raise NotOnBoard unless pos.all? { |x| x.between?(0, board.size - 1) }
  end

  private
  attr_accessor :previous_guess
  attr_reader :board
end

if __FILE__ == $PROGRAM_NAME
  size = ARGV.empty? ? 4 : ARGV.shift.to_i
  MemoryGame.new(ComputerPlayer.new(size), size).play
end
