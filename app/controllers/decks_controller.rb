class DecksController < ApplicationController
  def show
    @deck = Deck.find(params[:id])
  end

  def new
  end
end
