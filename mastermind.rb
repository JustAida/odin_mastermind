require "pry-byebug"

# Make Mastermind module that contains 3 classes: Game, Player, Computer

# Player class will have to guess the code until it matches or run out of guesses.
# It can also decide whether to be the codemaker or codebreaker.
# If codemaker is chosen then it'll ask for the secret code.
# If codebreaker is chosen then it'll ask for the guesses.

# Computer class will have two roles as well, codebreaker or codemaker.
# If codebreaker then it'll try to guess the code using an algorithm.
# If codemaker then it'll choose the secret code randomly.

module Mastermind
  # Game class will display the board that contains 12 rows with 4 holes each.
  # It will be played 12 turns, and it'll give information after each guess.
  # Information: Red Pegs indicate correct positions and colours while,
  #   White Pegs indicate correct colours but not the positions.
  # The game will stop if the guess is equal to the secret code or run out of guesses.
  # The secret code will be 4 colours out of 6 colours, for example [R-G-B-P].
  # The colours are [R, G, B, P, Y, O] -> [Red, Green, Blue, Pink, Yellow, Orange].
  class Game
    # Red, Green, Blue, Pink, Yellow, Orange
    COLOURS = %w[R G B P Y O]

    attr_accessor :turn, :red_pegs, :white_pegs

    def initialize(codemaker, codebreaker)
      @board = Array.new(12) { Array.new(4) }
      @board_str = ""
      @turn = 0
      # @pegs contain an Array of @red_pegs and @white_pegs for each turn.
      @pegs = []
      @red_pegs = 0
      @white_pegs = 0
      @codemaker = codemaker
      @codebreaker = codebreaker
    end

    def intro
      puts "Welcome to Mastermind game!"
      puts "When guessing the code or making the code you should type only 4 colours."
      puts "For example, rgbp or RGBP."
      puts "\nNow it's time for codemaker to type in the code."
    end

    def play
      intro
      # secret_code = @codemaker.get_secret_code UNCOMMENT THIS LATER
      puts "The codemaker has typed in the code."

      until turn == 2
        puts "\nGuess the code."
        # guess = @codebreaker.get_guess UNCOMMENT THIS LATER
        guess = "rgbp" # DELETE THIS AFTER
        update_board(guess)
        display
        self.turn += 1
      end
    end

    def display
      get_pegs("yyrb", "ryyy") if turn == 0 # DELETE THIS AFTER
      get_pegs("yyrb", "yyyy") if turn == 1 # DELETE THIS AFTER

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

    def update_board(guess)
      guess = guess.upcase.chars
      @board[turn] = guess
    end

    def get_pegs(secret_code, guess)
      secret_code = secret_code.upcase.chars
      guess = guess.upcase.chars
      secret_code_dup = secret_code[0..-1]
      guess_dup = guess[0..-1]

      # Check for red pegs.
      @red_pegs = 0
      secret_code_dup.each_with_index do |colour, index|
        if colour == guess[index]
          secret_code_dup[index] = nil
          guess_dup[index] = nil
          @red_pegs += 1
        end
      end

      # Check for white pegs.
      @white_pegs = secret_code_dup.select { |colour| guess_dup.include?(colour) && !colour.nil? }.size
      @pegs[turn] = [@red_pegs, @white_pegs]
    end

    # May have to change later.
    def check_guess(secret_code, guess)
      secret_code == guess
    end
  end
end

game = Mastermind::Game.new("", "")
game.play

