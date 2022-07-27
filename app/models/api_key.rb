class ApiKey < ApplicationRecord
  belongs_to :user
  validates :api_key, uniqueness: true
  before_create :init_api_key

  def init_api_key
    self.api_key = SecureRandom.alphanumeric(75)
    self.frequency = 0
  end

  def usage_limit
    { 1=> 500, 2=> 2000, 3=> 10000 }[subscription_type]
  end

  def reset_frequency
    frequency = 0
    created_at = Time.now
    save
  end

  def daily_limit_reached?
    return frequency >= usage_limit
  end

  def increment_usage!
    self.frequency += 1
    save
  end
end