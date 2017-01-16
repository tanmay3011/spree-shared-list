Spree.user_class.class_eval do
  has_many :sharedlists, dependent: :destroy
  has_many :shared_with_user, dependent: :destroy
  has_many :shared_sharedlists, through: :shared_with_user, source: :sharedlist
end
