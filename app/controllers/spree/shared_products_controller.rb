class Spree::SharedProductsController < Spree::StoreController
  respond_to :html

  before_action :load_shared_list, only: [:create]
  before_action :load_shared_product, only: [:update, :destroy]

  def create
    @shared_product = Spree::SharedProduct.new(shared_product_attributes)

    if @shared_list.include? @shared_product.variant_id
      @shared_product = @shared_list.shared_products.detect { |sp| sp.variant_id == @shared_product.variant_id }
    else
      @shared_product.shared_list = @shared_list
      @shared_product.save
    end

    respond_with(@shared_product) do |format|
      format.html { redirect_to shared_list_url(@shared_list) }
    end
  end

  def update
    @shared_product.update_attributes(shared_product_attributes)

    respond_with(@shared_product) do |format|
      format.html { redirect_to shared_list_url(@shared_product.shared_list) }
    end
  end

  def destroy
    @shared_product.destroy

    respond_with(@shared_product) do |format|
      format.html { redirect_to shared_list_url(@shared_product.shared_list) }
    end
  end

  private

  def shared_product_attributes
    params.require(:shared_product).permit(:variant_id, :shared_list_id, :quantity)
  end

  def load_shared_list
    unless @shared_list = Spree::SharedList.find_by(id: params[:shared_product][:shared_list_id])
      flash[:error] = Spree.t(:shared_list_not_found)
      redirect_to :root
    end
  end

  def load_shared_product
    @shared_product = Spree::SharedProduct.find_by(id: params[:id])
    unless @shared_product
      flash[:error] = Spree.t(:shared_product_not_found)
      redirect_to :root
    end
  end
end
