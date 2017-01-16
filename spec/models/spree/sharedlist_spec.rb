require 'spec_helper'

RSpec.describe Spree::Sharedlist, type: :model do

  describe 'Associations' do
    it { is_expected.to belong_to(:user).class_name(Spree.user_class) }
    it { is_expected.to have_many(:shared_products).dependent(:destroy) }
    it { is_expected.to have_many(:shared_with_user).dependent(:destroy) }
    it { is_expected.to have_many(:shared_users).through(:shared_with_user) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :name }
  end

end
