class Spree::SharedlistsController < Spree::StoreController
  helper 'spree/products'

  before_action :load_sharedlist, only: [:show, :edit, :update, :destroy, :share, :send_email]
  before_action :load_recipient, only: [:send_email]

  respond_to :html
  respond_to :js, only: :update

  def index
    @sharedlists = spree_current_user.sharedlists
    respond_with(@sharedlist)
  end

  def show
    respond_with(@sharedlist)
  end

  def new
    @sharedlist = Spree::Sharedlist.new
    respond_with(@sharedlist)
  end

  def create
    @sharedlist = Spree::Sharedlist.new(sharedlist_attributes)
    @sharedlist.user = spree_current_user
    @sharedlist.save
    respond_with(@sharedlist)
  end

  def edit
    respond_with(@sharedlist)
  end

  def update
    @sharedlist.update_attributes(sharedlist_attributes)
    respond_with(@sharedlist)
  end

  def destroy
    @sharedlist.destroy
    respond_with(@sharedlist) do |format|
      format.html { redirect_to account_path }
    end
  end

  def share
  end

  def send_email
    @shared_with_user = Spree::SharedWithUser.new
    @shared_with_user.sharedlist = @sharedlist
    @shared_with_user.user = @recipient
    @shared_with_user.sender_name = params[:sender_name]
    @shared_with_user.recipient_name = params[:recipient_name]
    if @shared_with_user.save
      flash[:success] = Spree.t(:success)
      redirect_to sharedlist_path(@sharedlist)
    end
    # respond_with(@shared_with_user)
  end

  private

  def sharedlist_attributes
    params.require(:sharedlist).permit(:name)
  end

  def load_sharedlist
    @sharedlist = Spree::Sharedlist.find_by(slug: params[:id])
    unless @sharedlist
      flash[:error] = Spree.t(:sharedlist_not_found)
      redirect_to :root
    end
  end

  def load_recipient
    @recipient = Spree.user_class.find_by(email: params[:recipient_email])
    unless @recipient
      flash[:error] = Spree.t(:recipient_not_found)
      redirect_to :back
    end
  end
end
