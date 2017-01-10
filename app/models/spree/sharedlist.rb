class Spree::Sharedlist < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class
  has_many :shared_products, dependent: :destroy

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  ## FIXME_NISH use friendly_id

  validates :name, presence: true

  def include?(variant_id)
    shared_products.map(&:variant_id).include? variant_id.to_i
  end

  def can_be_read_by?(user)
    ## FIXME_NISH do this by ability.rb
    user == self.user
  end

  ## FIXME Confirm this
  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def share_with(opts)
  end

end
