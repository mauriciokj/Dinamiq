class Poll < ApplicationRecord
  has_many :options, dependent: :destroy
  after_initialize :set_token, if: :new_record?
  accepts_nested_attributes_for :options, allow_destroy: true

  private
  def set_token
    self.token ||= SecureRandom.hex(4)
  end
end
