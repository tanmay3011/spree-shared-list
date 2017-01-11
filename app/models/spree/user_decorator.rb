Spree.user_class.class_eval do
  has_many :sharedlists, class_name: Spree::Sharedlist
  has_many :shared_with_user
  has_many :shared_sharedlists, through: :shared_with_user, source: :sharedlist
end
