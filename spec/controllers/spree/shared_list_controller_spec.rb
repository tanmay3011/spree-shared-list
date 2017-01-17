require 'spec_helper'

RSpec.describe Spree::SharedListsController, type: :controller do
  let(:shared_list) { create(:shared_list) }
  let(:user) { shared_list.user }
  let(:recipient) { create(:user) }
  let(:order) { create(:order) }
  let(:attributes) { attributes_for(:shared_list) }

  before { allow(controller).to receive(:spree_current_user).and_return(user) }

  describe 'Action Callbacks' do
    describe '#load_shared_list' do
      def send_request params
        spree_get :edit, params
      end

      context 'when shared_list is present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
        end

        before { send_request params }
        it { expect(response).to have_http_status 200 }
        it { expect(flash[:error]).to be_nil }
      end

      context 'when shared_list is not present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to eq(Spree.t(:shared_list_not_found)) }
        it { expect(response).to redirect_to root_path }
      end
    end

    describe '#load_recipient' do
      def send_request params
        spree_get :send_email, params
      end

      context 'when recipient is present' do
        let(:params) { { id: shared_list.id, recipient_email: recipient.email } }
        let(:mailer) { [] }
        before do
          allow(Spree::SharedListMailer).to receive(:share).and_return(mailer)
          allow(mailer).to receive(:deliver).and_return(true)
          allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
          allow(Spree.user_class).to receive(:find_by).and_return(recipient)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to be_nil }
      end

      context 'when recipient is not present' do
        let(:params) { { id: shared_list.id, recipient_email: recipient.email } }
        let(:mailer) { [] }
        before do
          allow(Spree::SharedListMailer).to receive(:share).and_return(mailer)
          allow(mailer).to receive(:deliver).and_return(true)
          allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
          allow(Spree.user_class).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to eq(Spree.t(:recipient_not_found)) }
        it { expect(response).to redirect_to share_shared_list_path(shared_list) }
      end
    end

    describe '#load_order' do
      def send_request params
        spree_post :checkout, params
      end

      context 'when order is present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
          allow(Spree.user_class).to receive(:find_by).and_return(recipient)
          allow(self).to receive(:current_order).and_return(order)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to be_nil }
      end

      context 'when order is not present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
          allow(Spree.user_class).to receive(:find_by).and_return(recipient)
          allow(self).to receive(:current_order).and_return(order)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to be_nil }
      end
    end

  end

  describe 'Actions' do
    describe 'GET index' do
      def send_request params
        spree_get :index
      end

      let(:params) { { id: shared_list.id } }
      before do
        allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
        allow(self).to receive(:spree_current_user).and_return(user)
      end

      describe 'response' do
        before { send_request params}
        it { expect(response).to have_http_status 200 }
        it { expect(response).to render_template :index }
      end
    end

    describe 'GET show' do
      def send_request paras
        spree_get :show, params
      end

      context 'when shared_list is present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 200 }
          it { expect(response).to render_template :show }
        end
      end

      context 'when shared_list is not present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(nil)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:shared_list_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'GET new' do
      def send_request paras
        spree_get :new, params
      end

      let(:params) { { } }

      describe 'response' do
        before { send_request params}
        it { expect(response).to have_http_status 200 }
        it { expect(response).to render_template :new }
      end
    end

    describe 'POST create' do
      def send_request paras
        spree_post :create, params
      end

      context 'When shared_list is valid' do
        let(:new_shared_list) { create(:shared_list) }
        let(:params) { { shared_list: { name: new_shared_list.name } } }
        before do
          allow(Spree::SharedList).to receive(:new).and_return(new_shared_list)
          allow(self).to receive(:spree_current_user).and_return(user)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(response).to redirect_to shared_list_path(new_shared_list) }
        end
      end

      context 'When shared_list is invalid' do
        let(:new_shared_list) { build(:shared_list, name: '') }
        let(:params) { { shared_list: { name: '' } } }
        before do
          allow(Spree::SharedList).to receive(:new).and_return(new_shared_list)
          allow(self).to receive(:spree_current_user).and_return(user)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 200 }
          it { expect(response).to render_template :new }
        end
      end
    end

    describe 'GET edit' do
      def send_request paras
        spree_get :edit, params
      end

      context 'when shared_list is present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 200 }
          it { expect(response).to render_template :edit }
        end
      end

      context 'when shared_list is not present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(nil)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:shared_list_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'PATCH update' do
      def send_request paras
        spree_patch :update, params
      end

      context 'When shared_list is present' do

        context 'When shared_list is valid' do
          let(:params) { { shared_list: { name: shared_list.name }, id: shared_list.name } }
          before do
            allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
            allow(@shared_list).to receive(:update_attributes).and_return(shared_list)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to shared_list_path(shared_list) }
          end
        end

        context 'When shared_list is invalid' do
          let(:params) { { shared_list: { name: shared_list.name }, id: shared_list.name } }
          before do
            allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
            allow(@shared_list).to receive(:update_attributes).and_return(false)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to shared_list_path(shared_list) }
          end
        end
      end

      context 'When shared_list is not present' do
        let(:params) { { shared_list: { name: shared_list.name }, id: shared_list.name } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(nil)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:shared_list_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'DELETE destroy' do
      def send_request paras
        spree_delete :destroy, params
      end

      context 'When shared_list is present' do
        context 'When shared_list is destroyed successfully' do
          let(:new_shared_list) { create(:shared_list) }
          let(:params) { { id: new_shared_list.name } }
          before do
            allow(Spree::SharedList).to receive(:find_by).and_return(new_shared_list)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to account_path }
          end
        end
        context 'When shared_list is not destroyed' do
          let(:new_shared_list) { create(:shared_list) }
          let(:params) { { id: new_shared_list.name } }
          before do
            allow(Spree::SharedList).to receive(:find_by).and_return(new_shared_list)
            allow(shared_list).to receive(:destroy).and_return(false)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to account_path }
          end
        end
      end

      context 'When shared_list is not present' do
        let(:params) { { shared_list: { name: shared_list.name }, id: shared_list.name } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(nil)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:shared_list_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'GET share' do
      def send_request paras
        spree_get :share, params
      end

      context 'when shared_list is present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 200 }
          it { expect(response).to render_template :share }
        end
      end

      context 'when shared_list is not present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(nil)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:shared_list_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'POST send_email' do
      def send_request paras
        spree_post :send_email, params
      end

      context 'When shared_list is present' do
        context 'when recipient is valid' do
          context 'When shared_list is successfully shared' do
            let(:params) { { id: shared_list.id } }
            let(:mailer) { [] }
            before do
              allow(Spree::SharedListMailer).to receive(:share).and_return(mailer)
              allow(mailer).to receive(:deliver).and_return(true)
              allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
              allow(Spree.user_class).to receive(:find_by).and_return(recipient)
            end

            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to shared_list_path(shared_list) }
            it { expect(flash[:error]).to be_nil }
          end

          context 'When shared_list is not successfully shared' do
            let(:params) { { id: shared_list.id } }
            let(:mailer) { [] }
            before do
              allow(Spree::SharedListMailer).to receive(:share).and_return(mailer)
              allow(mailer).to receive(:deliver).and_return(true)
              allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
              allow(Spree.user_class).to receive(:find_by).and_return(recipient)
            end

            before { send_request params }
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to share_shared_list_path(shared_list) }
            it { expect(flash[:error]).to eq("User already has access to this shared list") }
          end
        end

        context 'when recipient is not valid' do
          let(:params) { { id: shared_list.id, recipient_email: recipient.email } }
          let(:mailer) { [] }
          before do
            allow(Spree::SharedListMailer).to receive(:share).and_return(mailer)
            allow(mailer).to receive(:deliver).and_return(true)
            allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
            allow(Spree.user_class).to receive(:find_by).and_return(nil)
          end

          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:recipient_not_found)) }
          it { expect(response).to redirect_to share_shared_list_path(shared_list) }
        end
      end

      context 'When shared_list is not present' do
        let(:params) { { shared_list: { name: shared_list.name }, id: shared_list.name } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(nil)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:shared_list_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'POST checkout' do
      def send_request params
        spree_post :checkout, params
      end

      context 'when shared_list is present' do
        let(:params) { { id: shared_list.id } }
        let (:shared_product) { build(:shared_product) }
        let (:shared_product1) { build(:shared_product, quantity: 5) }
        context 'when all shared products are available' do
          before do
            allow(shared_list).to receive(:checkout).and_return('')
            allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to cart_path }
          end
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
            allow(Spree::SharedList).to receive(:find_by).and_return(shared_list)
            allow(shared_list).to receive(:checkout).and_return('Quantity ' + Spree.t(:selected_quantity_not_available, item: display_name ))
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(flash[:error]).to eq('Quantity ' + Spree.t(:selected_quantity_not_available, item: display_name )) }
            it { expect(response).to redirect_to shared_list_path(shared_list) }
          end
        end
      end

      context 'when shared_list is not present' do
        let(:params) { { id: shared_list.id } }
        before do
          allow(Spree::SharedList).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to eq(Spree.t(:shared_list_not_found)) }
        it { expect(response).to redirect_to root_path }
      end
    end

  end
end
