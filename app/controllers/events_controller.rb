class EventsController < ApplicationController
  def create
    @deck = Deck.find params[:deck_id]
    @event = @deck.events.build params[:event]
    case @event.action
    when /flip|draw/
      flip_or_draw @event.input
    when /play|discard/
      play_or_discard @event.input
    when 'random'
      discard_at_random @event.input
    when 'shuffle'
      shuffle
    when 'shuffle_all'
      shuffle_all
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

  private
  def flip_or_draw input
    if is_number? input
      if input.to_i > get_decks[@deck.deck_type].length - @deck.hand.length
        flash[:error] = "Can't #{@deck.action} that many cards"
      else
        shuffled = false
        cards1 = []
        cards2 = []
        input.to_i.times do
          card = @deck.cards.pop
          if card and not shuffled
            cards1 << card
          elsif card and shuffled
            cards2 << card
          else
            @deck.cards = get_decks[@deck.deck_type].shuffle - @deck.hand
            shuffled = true
          end
        end
        if @event.action == 'flip'
          if shuffled
            @event.output = "Flipped #{cards1.to_sentence}, shuffled the deck, and then flipped #{cards2.to_sentence}."
          else
            @event.output = "Flipped #{cards1.to_sentence}."
          end
        else
          @deck.hand += cards1
          @deck.hand += cards2
          if shuffled
            @event.output = "Drew #{cards1.to_sentence}, shuffled the deck, and then drew #{cards2.to_sentence}."
          else
            @event.output = "Drew #{cards1.to_sentence}."
          end
        end
      end
    end
  end

  def play_or_discard input
    cards = @event.input.split(',').map {|card| card.strip }
    bad_cards = cards.find_all {|card| !@deck.hand.member? card }
    if bad_cards.any?
      flash[:error] = "#{pluralize bad_cards.length, "invalid card"}: #{bad_cards.to_sentence}"
    else
      cards.each {|card| @deck.hand.delete card }
      if @event.action == 'play'
        @event.output = "Played #{cards.to_sentence}."
      else
        @event.output = "Discarded #{cards.to_sentence}."
      end
    end
  end
  
  def discard_at_random input
    if is_number? input
      if input.to_i > @deck.hand.length
        cards = input.to_i.times.map { @deck.hand.delete_at(rand(@deck.hand.length)) }
        @event.output = "Discarded #{cards.to_sentence} at random."
      else
        flash[:error] = "Not enough cards in hand"
      end
    end
  end

  def shuffle
    @deck.cards = get_decks[@deck.deck_type].suffle - @deck.hand
    @event.output = "Shuffled the deck."
  end

  def shuffle_all
    @deck.hand = []
    @deck.cards = get_decks[@deck.deck_type].shuffle
    @event.output = "Shuffled all cards into the deck."
  end

  def is_number? input
    if input.match /\D/
      flash[:error] = "Input should be a number"
      false
    else
      true
    end
  end
end
