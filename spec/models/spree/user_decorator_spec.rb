require 'spec_helper'

RSpec.describe Spree::User, type: :model do

  describe 'Associations' do
    it { is_expected.to have_many(:shared_lists).dependent(:destroy) }
    it { is_expected.to have_many(:shared_with_user).dependent(:destroy) }
    it { is_expected.to have_many(:shared_shared_lists).through(:shared_with_user) }
  end

end
