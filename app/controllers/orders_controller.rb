class OrdersController < ApplicationController
  layout 'table', only: [:index, :admin, :my]
  before_action :current_user_is_admin,       only: [:admin]
  before_action :current_user_can_write,      only: [:edit, :update, :destroy]  
  before_action :current_user_can_see_orders, only: [:index]
  before_action :current_user_can_see_order,  only: [:show]
  before_action :set_order,                   only: [:show, :edit, :update, :destroy]
  before_action :corrected_qty_update_only_for_expired_offer, only: [:update]

  # GET /offers/1/orders
  def index
    @offer = Offer.find(params[:offer_id])
    @offer_items = @offer.offer_items
    @orders = @offer.orders.joins(:user).order("orders.delivery_id, users.name")
    @offer_items_sum = OfferItemSummator.new(@offer, @orders).get_sum_hash

    @offer.company_name = @offer.user.company_name if @offer.user.try(:company_name).present?
    @offer.company_address = @offer.user.company_address if @offer.user.try(:company_address).present?
    @offer.company_oib = @offer.user.company_oib if @offer.user.try(:company_oib).present?
    
    @contact_form_url = message_to_orderers_offer_path(@offer)
    
    respond_to do |format|
      format.html
      format.csv { render csv: @offer.orders.
        includes(order_items: :offer_item, order_items: { order: { user: :group }}).
        references(order_items: :offer_item, order_items: { order: { user: :group }}), filename: "Pozitiva_ponuda_#{@offer.id}" }
    end
  end

  # GET /my_orders
  def my_orders
    @my_orders = current_user.orders.order('updated_at DESC').page(params[:page]).per(10)
  end

  # GET /admin_orders
  def admin
    @orders = Order.order('id DESC').page(params[:page]).per(10)
  end

  # GET /orders/1
  def show
  end

  # GET /orders/new
  def new
    # @order = Order.new
    @offer = Offer.find(params[:offer_id])
    @offer_items = @offer.offer_items
    @order = @offer.orders.build
  end

  # GET /orders/1/edit
  def edit
    @offer_items = @offer.offer_items
  end

  # POST /offers/1/orders
  def create
    @offer = Offer.find(params[:offer_id])
    @order = @offer.orders.build(order_params)
    @order.user = current_user

    if @order.save
      redirect_to [@offer,@order], notice: 'Order was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      if order_params_include_corrected_qty?
        redirect_to offer_orders_path(@offer), notice: 'Qty was successfully corrected.'        
      else
        redirect_to [@offer, @order], notice: 'Order was successfully updated.'
      end
    else
      render action: 'edit'
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    redirect_to my_orders_url, notice: 'Order was successfully destroyed.'
  end

  private
  
  def order_params_include_corrected_qty?
    order_params && 
      order_params["order_items_attributes"] && 
      order_params["order_items_attributes"]["0"] && 
      order_params["order_items_attributes"]["0"]["corrected_qty"].present? 
  end
  
  def corrected_qty_update_only_for_expired_offer
    if order_params_include_corrected_qty? && !@offer.expired?
      raise "[OrdersController#corrected_qty_update_only_for_expired_offer]"
    end
  end
  
  def offer_from_current_user?
    (current_user.offers.size > 0) && current_user.offers.exists?(id: params[:offer_id])
  end
  
  def order_from_current_user?
    current_user.orders.exists?(id: params[:id])
  end

  def current_user_is_admin?
    !!current_user.admin
  end

  def current_user_can_see_orders
    raise "[OrdersController#current_user_can_see_orders]" unless offer_from_current_user?
  end

  def current_user_can_see_order
    # Rails.logger.info "current_user: #{current_user.inspect}"
    # Rails.logger.info "current_user_is_admin: #{current_user.admin ? 'Yes' : 'No'}"
    # Rails.logger.info "offer_from_current_user: #{offer_from_current_user?}"
    # Rails.logger.info "order_from_current_user: #{order_from_current_user?}"
    
    raise "[OrdersController#current_user_can_see_order]" unless (current_user_is_admin? || offer_from_current_user? || order_from_current_user?)
  end

  def current_user_can_write
    raise "[OrdersController#current_user_can_write]" unless (order_from_current_user? || offer_from_current_user?)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @offer = Offer.find(params[:offer_id])
    @order = Order.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    params.require(:order).permit(:offer_id, :user_id, :delivery_id, :note, :status, 
      order_items:            [:id, :_destroy, :offer_item_id, :qty, :qty_description, :status, :corrected_qty],
      order_items_attributes: [:id, :_destroy, :offer_item_id, :qty, :qty_description, :status, :corrected_qty])
  end
end
