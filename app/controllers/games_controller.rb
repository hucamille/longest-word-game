require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(8)
  end

  def score
    @word = params[:word]
    @start_time = params[:start_time].to_datetime
    @end_time = Time.now
    @letter = params[:letter].split(',')
    @score = run_game(@word, @letter, @start_time, @end_time)[:score].to_i
    @message = run_game(@word, @letter, @start_time, @end_time)[:message]
  end

  # ancien jeu:
  # def generate_grid(grid_size)
  # TODO: generate random grid of letters
  # Array.new(grid_size) { ('A'..'Z').to_a.sample }
  # end

  def generate_grid(grid_size)
    @letters = []
    grid_size.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters
  end

  def result(length, time)
    length - time / 100000
  end

  def run_game(attempt, letter, start_time, end_time)
    api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
    list = {}
    open(api_url) do |stream|
      list = JSON.parse(stream.read)
    end
    if  (attempt.upcase.chars & letter == attempt.upcase.chars) && !list["Error"]
      your_translation = list["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"]
      your_score = result(attempt.length, end_time - start_time)
      return { time: end_time - start_time, translation: your_translation, score: result(attempt.length, end_time - start_time), message: message(your_score) }
    elsif list["Error"]
      return { time: end_time - start_time, translation: nil, score: 0, message: "not an english word" }
    elsif attempt.upcase.chars & letter != attempt.upcase.chars
      return { time: end_time - start_time, translation: your_translation, score: 0, message: "not in the letter" }
    end
  end

end
