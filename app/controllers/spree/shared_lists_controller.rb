class Spree::SharedListsController < Spree::StoreController
  helper 'spree/products'

  before_action :load_shared_list, only: [:show, :edit, :update, :destroy, :share, :send_email, :checkout]
  before_action :load_recipient, only: [:send_email]
  before_action :load_order, only: [:checkout]

  respond_to :html
  respond_to :js, only: :update

  def index
    @shared_lists = spree_current_user.shared_lists
    respond_with(@shared_list)
  end

  def show
    respond_with(@shared_list)
  end

  def new
    @shared_list = Spree::SharedList.new
    respond_with(@shared_list)
  end

  def create
    @shared_list = Spree::SharedList.new(shared_list_attributes)
    @shared_list.user = spree_current_user
    @shared_list.save
    respond_with(@shared_list)
  end

  def edit
    respond_with(@shared_list)
  end

  def update
    @shared_list.update_attributes(shared_list_attributes)
    respond_with(@shared_list)
  end

  def destroy
    @shared_list.destroy
    respond_with(@shared_list) do |format|
      format.html { redirect_to account_path }
    end
  end

  def share
  end

  def send_email
    @shared_with_user = Spree::SharedWithUser.new
    @shared_with_user.shared_list = @shared_list
    @shared_with_user.user = @recipient
    @shared_with_user.sender_name = params[:sender_name]
    @shared_with_user.recipient_name = params[:recipient_name]
    if @shared_with_user.save
      redirect_to shared_list_path(@shared_list)
    else
      flash[:error] = @shared_with_user.errors.full_messages.join(', ')
      redirect_to share_shared_list_path(@shared_list)
    end
  end

  def checkout
    errors = @shared_list.checkout(@order)
    if errors.empty?
      redirect_to cart_path
    else
      flash[:error] = errors
      redirect_to @shared_list
    end
  end

  private

  def shared_list_attributes
    params.require(:shared_list).permit(:name)
  end

  def load_shared_list
    @shared_list = Spree::SharedList.find_by(slug: params[:id])
    unless @shared_list
      flash[:error] = Spree.t(:shared_list_not_found)
      redirect_to :root
    end
  end

  def load_recipient
    @recipient = Spree.user_class.find_by(email: params[:recipient_email])
    unless @recipient
      flash[:error] = Spree.t(:recipient_not_found)
      redirect_to share_shared_list_path(@shared_list)
    end
  end

  def load_order
    @order = current_order(create_order_if_necessary: true)
  end
end
