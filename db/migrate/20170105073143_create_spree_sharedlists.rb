class CreateSpreeSharedlists < ActiveRecord::Migration
  def change
    create_table :spree_sharedlists do |t|
      t.references :user
      t.string :name
      t.string :access_hash
      t.boolean :is_private, default: true, null: false
      t.boolean :is_default, default: false, null: false

      t.timestamps null: false
    end

    add_index :spree_sharedlists, [:user_id]
    add_index :spree_sharedlists, [:user_id, :is_default]
  end
end
