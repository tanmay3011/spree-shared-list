require 'spec_helper'

RSpec.describe Spree::Variant, type: :model do

  describe 'Associations' do
    it { is_expected.to have_many(:shared_products).class_name('Spree::SharedProduct').dependent(:destroy) }
  end

end
