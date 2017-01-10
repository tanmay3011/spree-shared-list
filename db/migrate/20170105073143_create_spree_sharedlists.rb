class CreateSpreeSharedlists < ActiveRecord::Migration
  def change
    create_table :spree_sharedlists do |t|
      t.references :user
      t.string :name
      t.string :slug

      t.timestamps null: false
    end

    add_index :spree_sharedlists, [:user_id]
  end
end
