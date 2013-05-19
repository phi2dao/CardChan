class Event < ActiveRecord::Base
  attr_accessible :input, :action, :email
  belongs_to :deck

  validates :action, presence: true, inclusion: { in: %w[flip draw play discard shuffle] }
  validates :email, presence: true
  validates :output, presence: true
  validates :deck_id, presence: true

  default_scope order: 'events.created_at DESC'
end
