class EventsController < ApplicationController
  def create
    @deck = Deck.find params[:deck_id]
    @event = @deck.events.build params[:event]
    case @event.action
    when 'flip'
      cards = []
      @event.input.to_i.times { cards << @deck.cards.pop }
      @event.output = "Flipped #{cards.to_sentence}."
    when 'draw'
      cards = []
      @event.input.to_i.times { cards << @deck.cards.pop }
      @deck.hand += cards
      @event.output = "Drew #{cards.to_sentence}."
    when 'play'
      if @deck.hand.member? @event.input
        @deck.hand.delete @event.input
        @event.output = "Played #{@event.input}."
      end
    when 'discard'
      if @deck.hand.member? @event.input?
        @deck.hand.delete @event.input
        @event.output = "Discarded #{@event.input}."
      end
    when 'shuffle'
      @deck.cards = CARDS.dup.shuffle - @deck.hand
      @event.output = "Shuffled the deck."
    end
    unless @event.email == @deck.email
      @event.email = ""
      flash[:error] = "Invalid email"
    end
    if @event.save and @deck.save
      flash[:success] = "Action successful"
    else
      flash[:error] ||= "Action failed"
    end
    redirect_to @deck
  end

  def destroy
  end
end
