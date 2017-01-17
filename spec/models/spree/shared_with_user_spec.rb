require 'spec_helper'

RSpec.describe Spree::SharedWithUser, type: :model do

  describe 'Associations' do
    it { is_expected.to belong_to(:user).class_name(Spree.user_class.to_s) }
    it { is_expected.to belong_to(:shared_list) }
  end

  describe 'Validations' do
    subject { build(:shared_with_user) }
    let(:mailer) { [] }
    before do
      allow(Spree::SharedListMailer).to receive(:share).and_return(mailer)
      allow(mailer).to receive(:deliver).and_return(true)
    end
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:shared_list_id).with_message(Spree.t(:shared_list_already_shared_with_user)) }
  end

  describe 'Callbacks' do
    subject { create(:shared_with_user) }
    let(:mailer) { [] }
    before do
      allow(Spree::SharedListMailer).to receive(:share).and_return(mailer)
      allow(mailer).to receive(:deliver).and_return(true)
    end
    it { is_expected.to callback(:send_mail_to_recipient).after(:create) }
  end

end
