file_contents = File.read "5desk.txt"
words_array = file_contents.split()
words = words_array.select { |word| (word.length > 4) && (word.length < 13) }

puts "Let's play Hangman!"

current_word = words.sample(1)[0].downcase
current_word = current_word.split('')
guess_count = 8
display = Array.new(current_word.length, "_")
wrong_guesses = []

while guess_count > 0
  puts "You have #{guess_count} guesses left."
  puts "Enter your guess:"
  guess = gets.chomp.downcase
  matching_index = current_word.each_index.select { |index| current_word[index] == guess }
  matching_index.each { |index| display[index] = guess } unless matching_index.empty?
  #function to print the word to console


  if !display.any? { |char| char == "_" }
    puts "Current Word: " + display.join(" ")
    puts "You win!"
    return
  end

  if matching_index.empty?
    if !wrong_guesses.any? { |item| item == guess }
      wrong_guesses << guess
      guess_count -= 1
    end
  end
  puts
  puts 
  puts "Current Word: " + display.join(" ")
  puts
  puts "Letters you have already guessed: " + wrong_guesses.join(" ")
  puts
end

puts "SORRY! You lose."
puts "The word was: " + current_word.join(" ")
