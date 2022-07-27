class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :subscription_type, presence: true, inclusion: { in: [1,2,3] }
  has_many :api_keys

  def keys_limit
    { 1 => 5, 2 => 10, 3 => 9999999 }[subscription_type]
  end

  def keys_limit_reached?
    api_keys.count >= keys_limit
  end
end
