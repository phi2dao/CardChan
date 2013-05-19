class Event < ActiveRecord::Base
  attr_accessible :input, :action, :email
  belongs_to :deck

  before_save {|deck| deck.email = email.downcase }

  validates :action, presence: true, inclusion: { in: %w[flip draw play discard random shuffle shuffle_all] }
  validates :email, presence: true
  validates :output, presence: true
  validates :deck_id, presence: true

  default_scope order: 'events.created_at DESC'
end
