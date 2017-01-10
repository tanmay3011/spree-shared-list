class CreateSpreeSharedProducts < ActiveRecord::Migration
  def change
    create_table :spree_shared_products do |t|
      t.references :variant
      t.references :sharedlist
      t.text :remark
      t.integer :quantity, null: false, default: 1

      t.timestamps null: false
    end
  end
end
