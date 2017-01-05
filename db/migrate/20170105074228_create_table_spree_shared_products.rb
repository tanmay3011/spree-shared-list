class CreateTableSpreeSharedProducts < ActiveRecord::Migration
  def change
    create_table :table_spree_shared_products do |t|
      t.references :variant
      t.references :wishlist
      t.text :remark
      t.integer :quantity, null: false, default: 1

      t.timestamps null: false
    end
  end
end
