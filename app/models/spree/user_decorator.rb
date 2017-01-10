Spree.user_class.class_eval do
  has_many :sharedlists, class_name: Spree::Sharedlist
end
