class CreateSubscriptionChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_channels do |t|
      t.references :user, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
