class CreateSpreeSharedLists < ActiveRecord::Migration
  def change
    create_table :spree_shared_lists do |t|
      t.references :user
      t.string :name
      t.string :slug

      t.timestamps null: false
    end

    add_index :spree_shared_lists, [:user_id]
  end
end
