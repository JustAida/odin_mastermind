# Make Mastermind module that contains 3 classes: Game, Player, Computer

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
    attr_reader :pegs

    def initialize(codemaker, codebreaker)
      @board = Array.new(12) { Array.new(4) }
      @board_str = ""
      @turn = 0
      # @pegs contain an Array of @red_pegs and @white_pegs for each turn.
      @pegs = []
      @red_pegs = 0
      @white_pegs = 0
      roll = choose_role
      @codemaker = codemaker.new(self, true)
      @codebreaker = codebreaker.new(self, false)
      # Swap roles if the player choose to be codemaker instead.
      @codemaker, @codebreaker = @codebreaker, @codemaker if roll == 2
    end

    def choose_role
      puts "Choose the role [Type number only]."
      puts "1. Codemaker"
      puts "2. Codebreaker"
      role = ""
      loop do
        role = gets.chomp.to_i
        break if [1, 2].include?(role)
      end
      role
    end

    def intro
      puts "\nWelcome to Mastermind game!"
      puts "\nRules of the game:"
      puts "- Red Pegs indicate correct positions and colours."
      puts "- White Pegs indicate correct colours but not the positions."
      puts "- When guessing the code or making the code you should type only 4 colours."
      puts "- For example, rgbp or RGBP. [Duplicates are allowed but not blanks.]"
      puts "\nNow it's time for the Codemaker to choose the code."
      get_secret_code
    end

    def play
      intro
      until turn == 12
        get_guess
        puts "\n\nTurn: #{turn + 1}"
        update_board
        display
        self.turn += 1
        win_messages if correct_guess?
      end

      puts "\nYou've run out of guesses."
    end

    def get_secret_code
      loop do
        @secret_code = @codemaker.secret_code.upcase.chars
        break if valid_code?(@secret_code)

        puts "Please type the valid secret code."
      end
      puts "The Codemaker has chosen the code."
    end

    def get_guess
      loop do
        puts "\nGuess the code."
        @guess = @codebreaker.guess.upcase.chars
        break if valid_code?(@guess)
      end
    end

    def win_messages
      puts "\nThe Codebreaker guessed correctly!"
      puts "The Codebreaker has won!"
      exit
    end

    def display
      get_pegs(@secret_code, @guess, true)
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

    # Computer class will use this for calculation to get a guess.
    def get_pegs(secret_code, guess, store_pegs)
      secret_code_dup = secret_code[0..-1]
      guess_dup = guess[0..-1]

      # Check for red pegs.
      secret_code_dup, guess_dup = secret_code_and_guess_after_red_pegs(secret_code_dup, guess_dup)

      # Check for white pegs.
      check_white_pegs(secret_code_dup, guess_dup)
      @pegs[turn] = [@red_pegs, @white_pegs] if store_pegs
      [red_pegs, white_pegs]
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

    def check_white_pegs(secret_code, guess)
      @white_pegs = secret_code.reduce(0) do |count, colour|
        if guess.include?(colour) && !colour.nil?
          guess[guess.index(colour)] = nil
          count += 1
        else
          count
        end
      end
    end

    def correct_guess?
      @secret_code == @guess
    end

    def valid_code?(code)
      code.all? { |char| COLOURS.include?(char) } && code.length == 4
    end
  end

  # Player class will have to guess the code until it matches or run out of guesses.
  # It can be the codemaker or codebreaker.
  # If codemaker is chosen then it'll ask for the secret code.
  # If codebreaker is chosen then it'll ask for the guesses.
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

  # Computer class will have two roles as well, codebreaker or codemaker.
  # If codebreaker then it'll try to guess the code using an algorithm.
  # If codemaker then it'll choose the secret code randomly.
  class Computer < Player
    def initialize(game, codemaker)
      super(game, codemaker)
      return if codemaker

      @computer_guess = "RRGG"
      @possible_codes = []
      COLOURS.repeated_permutation(4) { |code| @possible_codes << code }
    end

    def remove_possible_codes
      @possible_codes = @possible_codes.select do |code|
        # Use current guess as a secret code and only select the codes that has the same amount of red and white pegs.
        red_pegs, white_pegs = @game.get_pegs(@computer_guess.upcase.chars, code, false)
        @game.pegs[@game.turn - 1] == [red_pegs, white_pegs]
      end
    end

    def guess
      unless @game.turn == 0
        remove_possible_codes
        @computer_guess = @possible_codes[@possible_codes.length / 2 - 1].join("")
      end
      p @computer_guess
      @computer_guess
    end

    def secret_code
      secret_guess = ""
      4.times { secret_guess += COLOURS.sample }
      secret_guess
    end
  end
end

game = Mastermind::Game.new(Mastermind::Player, Mastermind::Computer)
game.play
