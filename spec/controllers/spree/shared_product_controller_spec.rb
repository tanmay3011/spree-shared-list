require 'spec_helper'

RSpec.describe Spree::SharedProductsController, type: :controller do
  let(:sharedlist) { create(:sharedlist) }
  let(:user) { create(:user) }
  let(:shared_product) { create(:shared_product) }
  before { allow(controller).to receive(:spree_current_user).and_return(user) }

  describe 'Action Callbacks' do
    describe '#load_sharedlist' do
      def send_request params
        spree_post :create, params
      end

      context 'when sharedlist is present' do
        let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
        end

        before { send_request params }
        it { expect(flash[:error]).to be_nil }
      end

      context 'when sharedlist is not present' do
        let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
        it { expect(response).to redirect_to root_path }
      end
    end

    describe '#load_shared_product' do
      def send_request params
        spree_put :update, params
      end

      context 'when shared product is present' do
        let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
          allow(Spree::SharedProduct).to receive(:find_by).and_return(shared_product)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to be_nil }
      end

      context 'when shared product is not present' do
        let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
          allow(Spree::SharedProduct).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(response).to redirect_to root_path }
        it { expect(flash[:error]).to eq(Spree.t(:shared_product_not_found)) }
      end
    end

  end

  describe 'Actions' do

    describe 'POST create' do
      def send_request paras
        spree_post :create, params
      end

      let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
      context 'when sharedlist is present' do
        context 'when shared product is successfully created' do
          before do
            allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
            allow(Spree::SharedProduct).to receive(:new).and_return(shared_product)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to sharedlist_path(sharedlist) }
          end
        end
      end

      context 'when sharedlist is not present' do
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
        it { expect(response).to redirect_to root_path }
      end
    end

    describe 'PATCH update' do
      def send_request paras
        spree_patch :update, params
      end
      let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
      context 'when shared product is present' do
        context 'When shared product is updated successfully' do
          let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
          before do
            allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
            allow(Spree::SharedProduct).to receive(:find_by).and_return(shared_product)
          end

          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to be_nil }
        end
      end

      context 'when shared product is not present' do
        let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
          allow(Spree::SharedProduct).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(response).to redirect_to root_path }
        it { expect(flash[:error]).to eq(Spree.t(:shared_product_not_found)) }
      end
    end

    describe 'DELETE destroy' do
      def send_request paras
        spree_delete :destroy, params
      end
      let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
      context 'when shared product is present' do
        context 'when shared product is successfully deleted' do
          let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
          before do
            allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
            allow(Spree::SharedProduct).to receive(:find_by).and_return(shared_product)
          end

          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to be_nil }
        end
      end

      context 'when shared product is not present' do
        let(:params) { { id: shared_product.id, shared_product: { id: shared_product.id, sharedlist_id: sharedlist.id } } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
          allow(Spree::SharedProduct).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(response).to redirect_to root_path }
        it { expect(flash[:error]).to eq(Spree.t(:shared_product_not_found)) }
      end
    end

  end
end
