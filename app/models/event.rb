class Event < ActiveRecord::Base
  attr_accessible :card, :quantity, :action, :note
  belongs_to :deck

  validates :action, presence: true
  validates :note, length: { maximum: 140 }
  validates :deck_id, presence: true

  default_scope order: 'events.created_at DESC'
end
