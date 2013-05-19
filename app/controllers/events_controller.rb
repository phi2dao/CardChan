class EventsController < ApplicationController
  def create
    @deck = Deck.find params[:deck_id]
    @event = @deck.events.build params[:event]
    if @event.save
      if @event.type == 'play'
      elsif @event.type == 'discard'
      elsif @event.type == 'flip'
      elsif @event.type == 'draw'
      else
      end
      flash[:success] = "Action successful"
    end
    redirect_to @deck
  end

  def destroy
  end
end
