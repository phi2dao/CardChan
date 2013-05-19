class Deck < ActiveRecord::Base
  attr_accessible :subject, :email
  serialize :cards, Array
  serialize :hand, Array
  has_many :events, dependent: :destroy

  before_save {|deck| deck.email = email.downcase }

  validates :subject, presence: true, length: { maximum: 50 }
  validates :email, presence: true

  default_scope order: 'decks.updated_at DESC'
end
