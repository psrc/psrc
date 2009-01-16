class AddRefundPolicyToEvents < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :events, :refund_policy, :text
    end
  end

  def self.down
  end
end
