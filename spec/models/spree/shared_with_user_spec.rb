require 'spec_helper'

RSpec.describe Spree::SharedWithUser, type: :model do

  describe 'Associations' do
    it { is_expected.to belong_to(:user).class_name(Spree.user_class) }
    it { is_expected.to belong_to(:sharedlist) }
  end

  describe 'Validations' do

  end

end
