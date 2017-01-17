require 'spec_helper'

RSpec.describe Spree::SharedWithUser, type: :model do

  describe 'Associations' do
    it { is_expected.to belong_to(:user).class_name(Spree.user_class.to_s) }
    it { is_expected.to belong_to(:sharedlist) }
  end

  describe 'Validations' do
    subject { build(:shared_with_user) }
    let(:mailer) { [] }
    before do
      allow(Spree::SharedlistMailer).to receive(:share).and_return(mailer)
      allow(mailer).to receive(:deliver).and_return(true)
    end
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:sharedlist_id).with_message('already has access to this sharedlist') }
  end

  describe 'Callbacks' do
    subject { create(:shared_with_user) }
    let(:mailer) { [] }
    before do
      allow(Spree::SharedlistMailer).to receive(:share).and_return(mailer)
      allow(mailer).to receive(:deliver).and_return(true)
    end
    it { is_expected.to callback(:send_mail_to_recipient).after(:create) }
  end

end
