class AddSubscriptionTypeToApiKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :api_keys, :subscription_type, :integer
  end
end
