Deface::Override.new(
  virtual_path: 'spree/users/show',
  name: 'add_shared_list_to_my_account',
  insert_after: "[data-hook='account_my_orders']",
  partial: 'spree/users/shared_lists'
)
