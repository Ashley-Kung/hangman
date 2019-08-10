require 'yaml'

class Game

  def initialize
    @guess_count = 8
    @secret_word = choose_word
    @display = Array.new(@secret_word.length, "_")
    @wrong_guesses = []
    startup
  end

  def play_game
    display_word(@display)
    while @guess_count > 0
      puts "You have #{@guess_count} guesses left."
      puts "To save your game and come back later, type: save"
      puts "Enter your guess:"
      @guess = gets.chomp.downcase
      save_game if @guess == 'save'
      @matching_index = @secret_word.each_index.select { |index| @secret_word[index] == @guess }
      @matching_index.each { |index| @display[index] = @guess } unless @matching_index.empty?

      if won_game?(@display)
        display_word(@display)
        puts "You win!"
        return
      end

      if wrong_guess?(@guess, @matching_index, @wrong_guesses)
        @wrong_guesses << @guess
        @guess_count -= 1
      end

      display_turn_summary(@display, @wrong_guesses)
    end
    
    lose_game(@secret_word)
  end

  def startup
    puts "Welcome to Hangman!"
    puts "To load game type: load"
    puts "To start new game type: new"
    @gamechoice = gets.chomp
    self.play_game if @gamechoice == 'new'
    load_game if @gamechoice == 'load'
  end

  def to_s
    "   --Hangman Game--"
    "--Thanks for playing!--"
  end

  def inspect
    "   --Hangman Game--"
    "--Thanks for playing!--"
  end

  def save_game
    puts "Enter name for save file: "
    save = gets.chomp
    text_file = save + '.txt'
    File.open(text_file, 'w') { |file| file.write(YAML::dump(self)) }
    puts "Game has been saved as " + text_file
    exit
  end

  def load_game
    puts "Enter the name you saved the game under:"
    file = gets.chomp
    if File.exist?(file + ".txt")
      loadedgame = YAML::load(File.read(file + ".txt"))
      puts "Game is loaded!"
      puts
      puts
      display_word(@display)
      puts "Letters you have already guessed: " + @wrong_guesses
      loadedgame.play_game
    else
      puts "Game does not exist! Starting new game now..."
      play_game
    end
  end

  def display_word(display)
    puts "Secret Word: " + display.join(" ")
  end

  def display_turn_summary(display, wrong_guesses)
    puts
    puts 
    display_word(display)
    puts
    puts "Letters you have already guessed: " + wrong_guesses.join(" ")
    puts
  end

  def won_game?(display)
    !display.include? "_"
  end

  def lose_game(secret_word)
    puts "SORRY! You lose."
    puts "The word was: " + secret_word.join(" ")
  end

  def wrong_guess?(guess, matches, wrong_guesses)
    matches.empty? && (!wrong_guesses.any? { |item| item == guess })
  end

  def choose_word
    file_contents = File.read "5desk.txt"
    words_array = file_contents.split()
    words = words_array.select { |word| (word.length > 4) && (word.length < 13) }
    secret_word = words.sample(1)[0].downcase
    secret_word = secret_word.split('')
  end



end


