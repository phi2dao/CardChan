class ApplicationController < ActionController::Base
  protect_from_forgery

  def gen_deck ranks, suits, extras = []
    deck = extras
    suits.each do |suit|
      ranks.each do |rank|
        deck << "#{rank} of #{suit}"
      end
    end
    deck
  end

  def get_decks
    {
      'playing' => gen_deck(%w[Ace 2 3 4 5 6 7 8 9 10 Jack Queen King],
                            %w[Spades Hearts Diamonds Clubs],
                            ["Red Joker", "Black Joker"]),
      'tarot' => gen_deck(%w[Ace 2 3 4 5 6 7 8 9 10 Page Knight Queen King],
                          %w[Wands Pentacles Cups Swords],
                          ["The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lovers", "The Chariot", "Strength", "The Hermit", "Wheen of Fortune", "Justice", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World", "The Fool"])
    }
  end
end
