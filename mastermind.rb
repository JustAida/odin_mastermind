# Make Mastermind module that contains 3 classes: Game, Player, Computer

# Player class will have to guess the code until it matches or run out of guesses.
# It can also decide whether to be the codemaker or codebreaker.
# If codemaker is chosen then it'll ask for the secret code.
# If codebreaker is chosen then it'll ask for the guesses.

# Computer class will have two roles as well, codebreaker or codemaker.
# If codebreaker then it'll try to guess the code using an algorithm.
# If codemaker then it'll choose the secret code randomly.

module Mastermind
  # Red, Green, Blue, Pink, Yellow, Orange
  COLOURS = %w[R G B P Y O]

  # Game class will display the board that contains 12 rows with 4 holes each.
  # It will be played 12 turns, and it'll give information after each guess.
  # Information: Red Pegs indicate correct positions and colours while,
  #   White Pegs indicate correct colours but not the positions.
  # The game will stop if the guess is equal to the secret code or run out of guesses.
  # The secret code will be 4 colours out of 6 colours, for example [R-G-B-P].
  # The colours are [R, G, B, P, Y, O] -> [Red, Green, Blue, Pink, Yellow, Orange].
  class Game
    attr_accessor :turn, :red_pegs, :white_pegs

    def initialize(codemaker, codebreaker)
      @board = Array.new(12) { Array.new(4) }
      @board_str = ""
      @turn = 0
      # @pegs contain an Array of @red_pegs and @white_pegs for each turn.
      @pegs = []
      @red_pegs = 0
      @white_pegs = 0
      @codemaker = codemaker.new(self, true)
      @codebreaker = codebreaker.new(self, false)
    end

    def intro
      puts "Welcome to Mastermind game!"
      puts "When guessing the code or making the code you should type only 4 colours."
      puts "For example, rgbp or RGBP."
      puts "\nNow it's time for codemaker to type in the code."
      @secret_code = @codemaker.secret_code.upcase.chars
      puts "The codemaker has typed in the code."
    end

    def play
      intro
      until turn == 12
        get_guess
        puts "\n\nTurn: #{turn + 1}"
        update_board
        display
        self.turn += 1
        win_messages if check_guess
      end

      puts "\nYou've run out of guesses."
    end

    def get_guess
      puts "\nGuess the code."
      @guess = @codebreaker.guess.upcase.chars
    end

    def win_messages
      puts "\nYou've guessed correctly!"
      puts "You've won!"
      exit
    end

    def display
      get_pegs
      puts "\nGuesses | Red Pegs | White Pegs |"
      @board.each_with_index do |holes, index|
        next unless index == turn

        holes.each_with_index do |hole, hole_index|
          @board_str += hole.nil? ? "." : hole
          @board_str += hole_index == 3 ? " |    #{@pegs[turn][0]}     |     #{@pegs[turn][1]}      |\n" : "-"
        end
      end
      puts @board_str
    end

    def update_board
      @board[turn] = @guess
    end

    def get_pegs
      secret_code_dup = @secret_code[0..-1]
      guess_dup = @guess[0..-1]

      # Check for red pegs.
      secret_code_dup, guess_dup = secret_code_and_guess_after_red_pegs(secret_code_dup, guess_dup)

      # Check for white pegs.
      @white_pegs = secret_code_dup.select { |colour| guess_dup.include?(colour) && !colour.nil? }.size
      @pegs[turn] = [@red_pegs, @white_pegs]
    end

    def secret_code_and_guess_after_red_pegs(secret_code, guess)
      @red_pegs = 0
      secret_code.each_with_index do |colour, index|
        next unless colour == guess[index]

        secret_code[index] = nil
        guess[index] = nil
        @red_pegs += 1
      end
      [secret_code, guess]
    end

    def check_guess
      @secret_code == @guess
    end

    # ADD: A method to check for validity of a guess input.
    def valid_guess?
    end
  end

  class Player
    attr_reader :codemaker

    def initialize(game, codemaker)
      @game = game
      @codemaker = codemaker
    end

    def guess
      guess = gets.chomp
    end

    def secret_code
      secret_guess = gets.chomp
    end
  end

  class Computer < Player
    def guess
      # ADD: Algorithm
    end

    def secret_code
      secret_guess = ""
      4.times { secret_guess += COLOURS.sample }
      secret_guess
    end
  end
end

game = Mastermind::Game.new(Mastermind::Computer, Mastermind::Player)
game.play
