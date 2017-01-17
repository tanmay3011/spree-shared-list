Spree.user_class.class_eval do
  has_many :shared_lists, dependent: :destroy
  has_many :shared_with_user, dependent: :destroy
  has_many :shared_shared_lists, through: :shared_with_user, source: :shared_list
end
