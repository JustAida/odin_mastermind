# Make Mastermind module that contains 3 classes: Game, Player, Computer

# Game class will display the board that contains 12 rows with 4 holes each.
# It will be played 12 turns, and it'll give information after each guess.
# Information: Red Pegs indicate correct positions and colours while,
#   White Pegs indicate correct colours but not the positions.
# The game will stop if the guess is equal to the secret code or run out of guesses.
# The secret code will be 4 colours out of 6 colours, for example [R-G-B-P].
# The colours are [R, G, B, P, Y, O] -> [Red, Green, Blue, Pink, Yellow, Orange].

# Player class will have to guess the code until it matches or run out of guesses.
# It can also decide whether to be the codemaker or codebreaker.
# If codemaker is chosen then it'll ask for the secret code.
# If codebreaker is chosen then it'll ask for the guesses.

# Computer class will have two roles as well, codebreaker or codemaker.
# If codebreaker then it'll try to guess the code using an algorithm.
# If codemaker then it'll choose the secret code randomly.

module Mastermind
  class Game
    # Red, Green, Blue, Pink, Yellow, Orange
    COLOURS = %w[R G B P Y O]

    attr_accessor :turn, :red_pegs, :white_pegs

    def initialize(codemaker, codebreaker)
      @board = Array.new(12) { Array.new(4) }
      @turn = 12
      @red_pegs = 0
      @white_pegs = 0
    end

    def display
      @board.each_with_index do |holes, index|
        break if index > turn

        holes.each_with_index do |hole, hole_index|
          hole.nil? ? print(".") : print(hole)
          hole_index == 3 ? print("\n") : print("-")
        end
      end

      puts "\nRed Pegs: #{red_pegs}"
      puts "White Pegs: #{white_pegs}"
    end

  end
end

game = Mastermind::Game.new("", "")
game.display
