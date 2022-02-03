require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(8)
  end

  def score
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
end
