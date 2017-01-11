class Spree::SharedWithUser < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class
  belongs_to :sharedlist

  validates :user_id, uniqueness: { scope: :sharedlist_id, message: Spree.t(:sharedlist_shared_with_user) }

  after_create :send_mail_to_recipient

  private

  def send_mail_to_recipient
    Spree::SharedlistMailer.share(self).deliver_now
  end
end
