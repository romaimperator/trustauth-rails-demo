class MakePublicKeyUnique < ActiveRecord::Migration
  def up
    change_column :users, :public_key, :text, :unique => true
  end

  def down
    change_column :users, :public_key, :text, :unique => false
  end
end
