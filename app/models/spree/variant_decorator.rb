Spree::Variant.class_eval do
  has_many :shared_products, dependent: :destroy
end
