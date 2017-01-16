FactoryGirl.define do
  factory :sharedlist, class: Spree::Sharedlist do
    user
    sequence(:name) { |n| "Sharedlist_#{n}" }
  end
end
