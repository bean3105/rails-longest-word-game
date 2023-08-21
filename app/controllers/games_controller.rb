require 'open-uri'
require 'json'
require 'net/http'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def word_in_grid(word)
    @answer.chars.sort.all? { |letter| @grid.include?(letter) }
  end

  def english_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    response = Net::HTTP.get_response(URI.parse(url))
    data = response.body
    word = JSON.parse(data)
    word['found']
  end

  def score
    @answer = params[:word]
    @grid = params[:grid]
    @valid_word = english_dictionary(@answer)
    @letters_in_grid = word_in_grid(@answer)

    if @valid_word && @letters_in_grid
      @result = "Congratulation! #{@answer.upcase} is a valid English word."
    elsif @letters_in_grid != true
      @result = "Sorry, but #{@answer.upcase} can’t be built out of the letters provided."
    elsif @valid_word != true
      @result = "Sorry, but #{@answer.upcase} isn't a valid English word."
    elsif !@valid_word && @letters_in_grid
      @result = "Sorry, but #{@answer.upcase} isn't a valid English word."
    elsif @valid_word && !@letters_in_grid
      @result = "Sorry, but #{@answer.upcase} can’t be built out of #{grid_letters}."
    end
  end
end
