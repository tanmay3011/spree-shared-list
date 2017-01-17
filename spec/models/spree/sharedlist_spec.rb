require 'spec_helper'

RSpec.describe Spree::Sharedlist, type: :model do

  describe 'Associations' do
    it { is_expected.to belong_to(:user).class_name(Spree.user_class.to_s) }
    it { is_expected.to have_many(:shared_products).dependent(:destroy) }
    it { is_expected.to have_many(:shared_with_user).dependent(:destroy) }
    it { is_expected.to have_many(:shared_users).through(:shared_with_user) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of :name }
  end

  describe 'methods' do
    let(:sharedlist) { build(:sharedlist) }

    describe '#include?' do
      before do
        shared_product = build(:shared_product, variant_id: 1)
        sharedlist.shared_products << shared_product
      end
      context 'list includes a product with given variant_id' do
        it { expect(sharedlist.include?(1)).to be(true) }
      end
      context 'list doesnt include a product with given variant_id' do
        it { expect(sharedlist.include?(2)).to be(false) }
      end
    end

    describe '#should_generate_new_friendly_id?' do
      context 'list name has been changed' do
        before do
          sharedlist.name = 'new_name'
        end
        it { expect(sharedlist.should_generate_new_friendly_id?).to be(true) }
      end
      context 'list name has not been changed' do
        before do
          sharedlist.save
        end
        it { expect(sharedlist.should_generate_new_friendly_id?).to be(false) }
      end
    end

    describe '#checkout' do
      let (:sharedlist) { build(:sharedlist) }
      let (:shared_product) { build(:shared_product) }
      let (:shared_product1) { build(:shared_product, quantity: 5) }
      let (:order) { build(:order) }
      context 'when all shared products are available' do
        before do
          sharedlist.shared_product_ids = [shared_product.id]
          sharedlist.save
        end
        it { expect(sharedlist.checkout(order)).to eq('') }
      end

      context 'when some or all shared products are unavailable' do
        let(:display_name) do
          if (option_text = shared_product1.variant.options_text).present?
            "\"#{ shared_product1.variant.name } (#{ option_text })\""
          else
            variant.name
          end
        end
        before do
          shared_product1.variant.update(discontinue_on: Time.current - 1.day)
          shared_product1.save
          sharedlist.shared_product_ids = [shared_product1.id]
          sharedlist.save
        end
        it { expect(sharedlist.checkout(order)).to eq('Quantity ' + Spree.t(:selected_quantity_not_available, item: display_name )) }
      end
    end
  end

end
