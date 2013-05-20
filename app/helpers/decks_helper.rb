module DecksHelper
  def full_deck_type deck
    case deck.deck_type
    when 'playing'
      "Playing Cards"
    when 'tarot'
      "Tarot Cards"
    else
      "???"
    end
  end
end
