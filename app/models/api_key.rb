class ApiKey < ApplicationRecord
  belongs_to :user
  validates :api_key, uniqueness: true

  before_create :init_api_key

  def init_api_key
    self.api_key = SecureRandom.alphanumeric(75)
    self.frequency = 0
  end

  def self.has_exceeded_keys_limit?(current_user)
    subscription_type_of_current_user = current_user.get_subscription_type
    case subscription_type_of_current_user
    when 1
      current_user.api_keys.count >= 5
    when 2
      current_user.api_keys.count >= 10
    when 3
      return false
    end
  end

  def self.validate_api_key(api_key)
    return self.find_by(api_key: api_key)
  end

  def self.check_daily_limit(api_key)
    api_key_frequency = self.find_by(api_key: api_key).frequency
    api_key_created_at = self.find_by(api_key: api_key).created_at
    one_day_from_created_at = api_key_created_at + 1.day
    if self.find_by(api_key:api_key).subscription_type == 1
      if Time.now - 1.day >= api_key_created_at
        self.find_by(api_key: api_key).update(frequency:1,created_at: Time.now)
        return
      end

      if Time.now < one_day_from_created_at && api_key_frequency + 1 > 500
        return "Daily Quota Exceeded"
      end

      if Time.now < one_day_from_created_at && api_key_frequency + 1 <= 500
        self.find_by(api_key: api_key).update(frequency:api_key_frequency+1)
        return
      end
    elsif self.find_by(api_key:api_key).subscription_type == 2
      if Time.now - 1.day >= api_key_created_at
        self.find_by(api_key: api_key).update(frequency:1,created_at: Time.now)
        return
      end

      if Time.now < one_day_from_created_at && api_key_frequency + 1 > 2000
        return "Daily Quota Exceeded"
      end

      if Time.now < one_day_from_created_at && api_key_frequency + 1 <= 2000
        self.find_by(api_key: api_key).update(frequency:api_key_frequency+1)
        return
      end
    elsif self.find_by(api_key:api_key).subscription_type == 3
      if Time.now - 1.day >= api_key_created_at
        self.find_by(api_key: api_key).update(frequency:1,created_at: Time.now)
        return
      end

      if Time.now < one_day_from_created_at && api_key_frequency + 1 > 10000
        return "Daily Quota Exceeded"
      end

      if Time.now < one_day_from_created_at && api_key_frequency + 1 <= 10000
        self.find_by(api_key: api_key).update(frequency:api_key_frequency+1)
        return
      end
    end
  end
end
