Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_shared_list_to_cart_form',
  insert_bottom: "[data-hook='cart_form']",
  partial: 'spree/products/shared_list_form'
)
