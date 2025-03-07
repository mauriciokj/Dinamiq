class Option < ApplicationRecord
  belongs_to :poll
  has_many :votes, dependent: :destroy
  
  # Garantir ordem de criação
  default_scope -> { order(id: :asc) }

  def votes_count
    votes.count
  end
end
