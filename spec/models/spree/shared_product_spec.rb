require 'spec_helper'

RSpec.describe Spree::SharedProduct, type: :model do

  describe 'Associations' do
    it { is_expected.to belong_to(:variant) }
    it { is_expected.to belong_to(:sharedlist) }
  end

  describe 'Methods' do

    describe '#amount' do
      context 'an explicit value of quantity is present' do
        before do
          @shared_product = build(:shared_product, quantity: 5)
          @shared_product.variant = build(:variant, price: 10)
        end
        it { expect(@shared_product.amount).to eq(50) }
      end

      context 'quantity is set to default value' do
        before do
          @shared_product = build(:shared_product)
          @shared_product.variant = build(:variant, price: 10)
        end
        it { expect(@shared_product.amount).to eq(10) }
      end
    end

    describe '#display_total' do
      before do
        @shared_product = build(:shared_product, quantity: 5)
        @shared_product.variant = build(:variant, price: 10)
      end
      it { expect(@shared_product.display_total.to_s).to eq("$50.00") }
    end

    describe '#add_to_current_order' do
      let (:shared_product) { build(:shared_product) }
      let (:shared_product1) { build(:shared_product, quantity: 5) }
      let (:order) { build(:order) }

      context 'when quantity is available' do
        it { expect(shared_product.add_to_current_order(order)). to eq('') }
      end

      context 'when quantity is not available' do
        let(:display_name) do
          if (option_text = shared_product1.variant.options_text).present?
            "\"#{ shared_product1.variant.name } (#{ option_text })\""
          else
            variant.name
          end
        end
        before do
          allow(shared_product1.variant).to receive(:available?).and_return(false)
        end
        it { expect(shared_product1.add_to_current_order(order)). to eq('Quantity ' + Spree.t(:selected_quantity_not_available, item: display_name )) }
      end
  end

  end

end
