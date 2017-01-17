FactoryGirl.define do

  factory :shared_product, class: Spree::SharedProduct do
    variant
    sharedlist
    quantity 1
  end

  factory :sharedlist, class: Spree::Sharedlist do
    user
    sequence(:name) { |n| "Sharedlist_#{n}" }
  end

  factory :shared_with_user, class: Spree::SharedWithUser do
    user
    sharedlist
  end

end

