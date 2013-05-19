class DecksController < ApplicationController
  def index
    @deck = Deck.new
    @decks = Deck.paginate page: params[:page]
  end

  def create
    @deck = Deck.new params[:deck]
    @deck.cards = CARDS.dup.shuffle
    @deck.hand = []
    if @deck.save
      while Deck.count > 180
        Deck.last.destroy
      end
      redirect_to @deck
    else
      render 'new'
    end
  end

  def new
    @deck = Deck.new
  end

  def show
    @deck = Deck.find params[:id]
    @event = @deck.events.build
    @events = @deck.events.paginate page: params[:page]
  end
end
