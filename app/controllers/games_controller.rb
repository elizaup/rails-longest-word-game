# frozen_string_literal: true

# require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  # if the user word matches letters and is a valid work, then POST to form?

  # this method is for the score view, the 2nd page
  # in order to implement some logic in the 2nd page, we need to make some methods accessible
  # 1. letters, we display the letters on to the first page but then want to pass these exact letters on to the 2nd page
  # do this by creating a hidden field in the form, the user answer is then associated with these exact set of letters
  # <%= hidden_field_tag :letters, @letters%>
  # 2. word, we pass the word the user inputs or space
  # 3. instance variables are accesible in the view, so we store methods that will check the user input
  # into instance variables, and pass parameters as instance variables

  # is this always the same structure, one method per page?

  def score
    @letters = params[:letters].split
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letters)
    @valid_word = valid_word?(@word)
  end

  private

  # does the user's word match letters in the grid i.e. in @letters

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  #   # is the user's word a valid word

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found'] # word is valid if json API returns found for word
  end
end
