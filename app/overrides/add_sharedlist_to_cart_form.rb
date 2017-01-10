Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_sharedlist_to_cart_form',
  insert_bottom: "[data-hook='cart_form']",
  partial: 'spree/products/sharedlist_form'
)
