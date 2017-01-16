FactoryGirl.define do
  factory :shared_product, class: Spree::SharedProduct do
    variant
    sharedlist
  end
end
