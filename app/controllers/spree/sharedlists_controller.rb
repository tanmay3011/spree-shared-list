class Spree::SharedlistsController < Spree::StoreController
  helper 'spree/products'

  before_action :find_sharedlist, only: [:destroy, :show, :update, :edit]

  respond_to :html
  respond_to :js, only: :update

  def new
    @sharedlist = Spree::Sharedlist.new
    respond_with(@sharedlist)
  end

  def index
    @sharedlists = spree_current_user.sharedlists
    respond_with(@sharedlist)
  end

  def edit
    respond_with(@sharedlist)
  end

  def update
    @sharedlist.update_attributes sharedlist_attributes
    respond_with(@sharedlist)
  end

  def show
    respond_with(@sharedlist)
  end

  def default
    @sharedlist = spree_current_user.sharedlist
    respond_with(@sharedlist) do |format|
      format.html { render :show }
    end
  end

  def create
    @sharedlist = Spree::Sharedlist.new sharedlist_attributes
    @sharedlist.user = spree_current_user
    @sharedlist.save
    respond_with(@sharedlist)
  end

  def destroy
    @sharedlist.destroy
    respond_with(@sharedlist) do |format|
      format.html { redirect_to account_path }
    end
  end

  private

  def sharedlist_attributes
    params.require(:sharedlist).permit(:name, :is_default, :is_private)
  end

  # Isolate this method so it can be overwritten
  def find_sharedlist
    @sharedlist = Spree::Sharedlist.find_by_access_hash!(params[:id])
  end
end
