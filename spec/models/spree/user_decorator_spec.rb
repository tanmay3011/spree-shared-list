require 'spec_helper'

RSpec.describe Spree::User, type: :model do

  describe 'Associations' do
    it { is_expected.to have_many(:sharedlists).dependent(:destroy) }
    it { is_expected.to have_many(:shared_with_user).dependent(:destroy) }
    it { is_expected.to have_many(:shared_sharedlists).through(:shared_with_user) }
  end

end
