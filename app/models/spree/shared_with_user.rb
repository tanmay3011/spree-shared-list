class Spree::SharedWithUser < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class
  belongs_to :shared_list

  validates :user_id, uniqueness: { scope: :shared_list_id, message: Spree.t(:shared_list_already_shared_with_user) }

  after_create :send_mail_to_recipient

  private

  def send_mail_to_recipient
    Spree::SharedListMailer.share(self).deliver
  end
end
