class Admin::ProductsController < Admin::BaseController
  before_action :get_order
  before_action :get_product, except: [:index, :new, :create]

  def index
    @products = @week.products
  end

  def new
    @product = @week.products.new
  end

  def create
    @product = @week.products.new(product_params)
    if @product.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to action: :index
  end

  private

  def get_order
    @week = Week.find params[:week_id]
  end

  def get_product
    @product = @week.products.find params[:id]
  end

  def product_params
    params.require(:product).permit!
  end
end
