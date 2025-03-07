class Vote < ApplicationRecord
  belongs_to :poll
  belongs_to :option
  validates :user_uid, uniqueness: { scope: :poll_id }
  belongs_to :option, counter_cache: :votes_count
end
