class EventsController < ApplicationController
  def create
    @deck = Deck.find params[:deck_id]
    @event = @deck.events.build params[:event]
    case @event.action
    when /flip|draw/
      if @event.input.to_i > @deck.cards.length
        flash[:error] = "Not enough cards in the deck"
      else
        cards = []
        @event.input.to_i.times { cards << @deck.cards.pop }
        if cards.empty?
          flash[:error] = "Bad number of cards"
        else
          if @event.action == 'flip'
            @event.output = "Flipped #{cards.to_sentence}."
          else
            @deck.hand += cards
            @event.output = "Drew #{cards.to_sentence}."
          end
        end
      end
    when /play|discard/
      cards = @event.input.split(',').map {|card| card.strip }
      if (cards & @deck.hand).length != cards.length
        flash[:error] = pluralize(cards.length - (cards & @deck.hand).length, "invalid card")
      else
        cards.each do |card|
          @deck.hand.delete card
        end
        if @event.action == 'play'
          @event.output = "Played #{cards.to_sentence}."
        else
          @event.output = "Discarded #{cards.to_sentence}."
        end
      end
    when 'random'
      if @event.input.to_i > @deck.hand.length
        flash[:error] = "Not enough cards in hand"
      else
        cards = []
        @event.input.to_i.times { cards << @deck.hand.delete_at(rand(@deck.hand.length)) }
        if cards.empty?
          flash[:error] = "Bad number of cards"
        else
          @event.output = "Discarded #{cards.to_sentence} at random."
        end
      end
    when 'shuffle'
      @deck.cards = CARDS.dup.shuffle - @deck.hand
      @event.output = "Shuffled the deck."
    when 'shuffle_all'
      @deck.hand = []
      @deck.cards = CARDS.dup.shuffle
      @event.output = "Shuffled all cards into the deck."
    end
    unless @event.email.downcase == @deck.email
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

  def show
    @event = Event.find params[:id]
  end
end
