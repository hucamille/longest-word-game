require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].chars
    @word = params[:word].upcase
    @result = 0
    if not_in_grid?(@word, @letters)
      @result = 1
    elsif not_english?(@word)
      @result = 2
    end
  end

  private

  def not_in_grid?(word, letters)
    letters_combinations = letters.combination(word.length).to_a
    attempt_characters = word.chars
    result = true
    letters_combinations.each do |combination|
      if combination.sort == attempt_characters.sort
        result = false
        break
      end
    end
    result
  end

  def not_english?(word)
    wagon_dictionary_url = "https://wagon-dictionary.herokuapp.com/#{word}"
    wagon_dictionary_answer = open(wagon_dictionary_url).read
    !JSON.parse(wagon_dictionary_answer)["found"]
  end
end
