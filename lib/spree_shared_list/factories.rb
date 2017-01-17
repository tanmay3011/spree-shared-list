FactoryGirl.define do

  factory :shared_product, class: Spree::SharedProduct do
    variant
    shared_list
    quantity 1
  end

  factory :shared_list, class: Spree::SharedList do
    user
    sequence(:name) { |n| "Shared_list_#{n}" }
  end

  factory :shared_with_user, class: Spree::SharedWithUser do
    user
    shared_list
  end

end

