require 'spec_helper'

RSpec.describe Spree::SharedlistsController, type: :controller do
  let(:sharedlist) { create(:sharedlist) }
  let(:user) { sharedlist.user }
  let(:recipient) { create(:user) }
  let(:order) { create(:order) }
  let(:attributes) { attributes_for(:sharedlist) }

  before { allow(controller).to receive(:spree_current_user).and_return(user) }

  describe 'Action Callbacks' do
    describe '#load_sharedlist' do
      def send_request params
        spree_get :edit, params
      end

      context 'when sharedlist is present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
        end

        before { send_request params }
        it { expect(response).to have_http_status 200 }
        it { expect(flash[:error]).to be_nil }
      end

      context 'when sharedlist is not present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
        it { expect(response).to redirect_to root_path }
      end
    end

    describe '#load_recipient' do
      def send_request params
        spree_get :send_email, params
      end

      context 'when recipient is present' do
        let(:params) { { id: sharedlist.id, recipient_email: recipient.email } }
        let(:mailer) { [] }
        before do
          allow(Spree::SharedlistMailer).to receive(:share).and_return(mailer)
          allow(mailer).to receive(:deliver).and_return(true)
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
          allow(Spree.user_class).to receive(:find_by).and_return(recipient)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to be_nil }
      end

      context 'when recipient is not present' do
        let(:params) { { id: sharedlist.id, recipient_email: recipient.email } }
        let(:mailer) { [] }
        before do
          allow(Spree::SharedlistMailer).to receive(:share).and_return(mailer)
          allow(mailer).to receive(:deliver).and_return(true)
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
          allow(Spree.user_class).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to eq(Spree.t(:recipient_not_found)) }
        it { expect(response).to redirect_to share_sharedlist_path(sharedlist) }
      end
    end

    describe '#load_order' do
      def send_request params
        spree_post :checkout, params
      end

      context 'when order is present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
          allow(Spree.user_class).to receive(:find_by).and_return(recipient)
          allow(self).to receive(:current_order).and_return(order)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to be_nil }
      end

      context 'when order is not present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
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

      let(:params) { { id: sharedlist.id } }
      before do
        allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
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

      context 'when sharedlist is present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 200 }
          it { expect(response).to render_template :show }
        end
      end

      context 'when sharedlist is not present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
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

      context 'When sharedlist is valid' do
        let(:new_sharedlist) { create(:sharedlist) }
        let(:params) { { sharedlist: { name: new_sharedlist.name } } }
        before do
          allow(Spree::Sharedlist).to receive(:new).and_return(new_sharedlist)
          allow(self).to receive(:spree_current_user).and_return(user)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(response).to redirect_to sharedlist_path(new_sharedlist) }
        end
      end

      context 'When sharedlist is invalid' do
        let(:new_sharedlist) { build(:sharedlist, name: '') }
        let(:params) { { sharedlist: { name: '' } } }
        before do
          allow(Spree::Sharedlist).to receive(:new).and_return(new_sharedlist)
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

      context 'when sharedlist is present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 200 }
          it { expect(response).to render_template :edit }
        end
      end

      context 'when sharedlist is not present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'PATCH update' do
      def send_request paras
        spree_patch :update, params
      end

      context 'When sharedlist is present' do

        context 'When sharedlist is valid' do
          let(:params) { { sharedlist: { name: sharedlist.name }, id: sharedlist.name } }
          before do
            allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
            allow(@sharedlist).to receive(:update_attributes).and_return(sharedlist)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to sharedlist_path(sharedlist) }
          end
        end

        context 'When sharedlist is invalid' do
          let(:params) { { sharedlist: { name: sharedlist.name }, id: sharedlist.name } }
          before do
            allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
            allow(@sharedlist).to receive(:update_attributes).and_return(false)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to sharedlist_path(sharedlist) }
          end
        end
      end

      context 'When sharedlist is not present' do
        let(:params) { { sharedlist: { name: sharedlist.name }, id: sharedlist.name } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'DELETE destroy' do
      def send_request paras
        spree_delete :destroy, params
      end

      context 'When sharedlist is present' do
        context 'When sharedlist is destroyed successfully' do
          let(:new_sharedlist) { create(:sharedlist) }
          let(:params) { { id: new_sharedlist.name } }
          before do
            allow(Spree::Sharedlist).to receive(:find_by).and_return(new_sharedlist)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to account_path }
          end
        end
        context 'When sharedlist is not destroyed' do
          let(:new_sharedlist) { create(:sharedlist) }
          let(:params) { { id: new_sharedlist.name } }
          before do
            allow(Spree::Sharedlist).to receive(:find_by).and_return(new_sharedlist)
            allow(sharedlist).to receive(:destroy).and_return(false)
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to account_path }
          end
        end
      end

      context 'When sharedlist is not present' do
        let(:params) { { sharedlist: { name: sharedlist.name }, id: sharedlist.name } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'GET share' do
      def send_request paras
        spree_get :share, params
      end

      context 'when sharedlist is present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 200 }
          it { expect(response).to render_template :share }
        end
      end

      context 'when sharedlist is not present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end

        describe 'response' do
          before { send_request params}
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'POST send_email' do
      def send_request paras
        spree_post :send_email, params
      end

      context 'When sharedlist is present' do
        context 'when recipient is valid' do
          context 'When sharedlist is successfully shared' do
            let(:params) { { id: sharedlist.id } }
            let(:mailer) { [] }
            before do
              allow(Spree::SharedlistMailer).to receive(:share).and_return(mailer)
              allow(mailer).to receive(:deliver).and_return(true)
              allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
              allow(Spree.user_class).to receive(:find_by).and_return(recipient)
            end

            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to sharedlist_path(sharedlist) }
            it { expect(flash[:error]).to be_nil }
          end

          context 'When sharedlist is not successfully shared' do
            let(:params) { { id: sharedlist.id } }
            let(:mailer) { [] }
            before do
              allow(Spree::SharedlistMailer).to receive(:share).and_return(mailer)
              allow(mailer).to receive(:deliver).and_return(true)
              allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
              allow(Spree.user_class).to receive(:find_by).and_return(recipient)
            end

            before { send_request params }
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(response).to redirect_to share_sharedlist_path(sharedlist) }
            it { expect(flash[:error]).to eq("User already has access to this sharedlist") }
          end
        end

        context 'when recipient is not valid' do
          let(:params) { { id: sharedlist.id, recipient_email: recipient.email } }
          let(:mailer) { [] }
          before do
            allow(Spree::SharedlistMailer).to receive(:share).and_return(mailer)
            allow(mailer).to receive(:deliver).and_return(true)
            allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
            allow(Spree.user_class).to receive(:find_by).and_return(nil)
          end

          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:recipient_not_found)) }
          it { expect(response).to redirect_to share_sharedlist_path(sharedlist) }
        end
      end

      context 'When sharedlist is not present' do
        let(:params) { { sharedlist: { name: sharedlist.name }, id: sharedlist.name } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end
        describe 'response' do
          before { send_request params }
          it { expect(response).to have_http_status 302 }
          it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
          it { expect(response).to redirect_to root_path }
        end
      end
    end

    describe 'POST checkout' do
      def send_request params
        spree_post :checkout, params
      end

      context 'when sharedlist is present' do
        let(:params) { { id: sharedlist.id } }
        let (:shared_product) { build(:shared_product) }
        let (:shared_product1) { build(:shared_product, quantity: 5) }
        context 'when all shared products are available' do
          before do
            allow(sharedlist).to receive(:checkout).and_return('')
            allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
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
            allow(Spree::Sharedlist).to receive(:find_by).and_return(sharedlist)
            allow(sharedlist).to receive(:checkout).and_return('Quantity ' + Spree.t(:selected_quantity_not_available, item: display_name ))
          end
          describe 'response' do
            before { send_request params }
            it { expect(response).to have_http_status 302 }
            it { expect(flash[:error]).to eq('Quantity ' + Spree.t(:selected_quantity_not_available, item: display_name )) }
            it { expect(response).to redirect_to sharedlist_path(sharedlist) }
          end
        end
      end

      context 'when sharedlist is not present' do
        let(:params) { { id: sharedlist.id } }
        before do
          allow(Spree::Sharedlist).to receive(:find_by).and_return(nil)
        end

        before { send_request params }
        it { expect(response).to have_http_status 302 }
        it { expect(flash[:error]).to eq(Spree.t(:sharedlist_not_found)) }
        it { expect(response).to redirect_to root_path }
      end
    end

  end
end
