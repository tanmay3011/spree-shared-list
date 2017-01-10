class Spree::SharedProductsController < Spree::StoreController
  respond_to :html

  before_action :load_sharedlist, only: [:create]
  before_action :load_shared_product, only: [:update, :destroy]

  def create
    @shared_product = Spree::SharedProduct.new(shared_product_attributes)

    if @sharedlist.include? @shared_product.variant_id
      @shared_product = @sharedlist.shared_products.detect { |sp| sp.variant_id == @shared_product.variant_id }
    else
      @shared_product.sharedlist = @sharedlist
      @shared_product.save
    end

    respond_with(@shared_product) do |format|
      format.html { redirect_to sharedlist_url(@sharedlist) }
    end
  end

  def update
    @shared_product.update_attributes(shared_product_attributes)

    respond_with(@shared_product) do |format|
      format.html { redirect_to sharedlist_url(@shared_product.sharedlist) }
    end
  end

  def destroy
    @shared_product.destroy

    respond_with(@shared_product) do |format|
      format.html { redirect_to sharedlist_url(@shared_product.sharedlist) }
    end
  end

  private

  def shared_product_attributes
    params.require(:shared_product).permit(:variant_id, :sharedlist_id, :remark, :quantity)
  end

  def load_sharedlist
    unless @sharedlist = Spree::Sharedlist.find_by(id: params[:shared_product][:sharedlist_id])
      flash[:error] = Spree.t(:sharedlist_not_found)
      redirect_to :root
    end
  end

  def load_shared_product
    @shared_product = Spree::SharedProduct.find(params[:id])
    unless @shared_product
      flash[:error] = Spree.t(:shared_product_not_found)
      redirect_to :root
    end
  end
end
