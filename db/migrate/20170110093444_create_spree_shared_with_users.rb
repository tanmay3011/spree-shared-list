class CreateSpreeSharedWithUsers < ActiveRecord::Migration
  def change
    create_table :spree_shared_with_users do |t|
      t.references :sharedlist
      t.references :user
      t.string :sender_name
      t.string :recipient_name

      t.timestamps null: false
    end
  end
end
