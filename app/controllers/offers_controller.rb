class OffersController < ApplicationController
  layout 'table', only: [:admin]
  
  before_action :current_user_is_admin, only: :admin
  before_action :current_user_can_read,  only: [:show]
  before_action :current_user_can_write, only: [:edit, :update, :destroy, :duplicate]
  before_action :current_user_can_publish_offer, only: [:edit, :update, :destroy, :duplicate, :new, :my_offers]
  before_action :set_offer, only: [:show, :edit, :update, :destroy, :duplicate, :deactivate, :attach, :delete_attach, :message_to_orderers]
  
  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.published.joins(:group_offerings).where("group_offerings.group_id = ? ", current_user.group_id)
    @my_offers = Offer.where(user_id: current_user.id)
    @current_user_order_in_offer_ids = @offers.map{ |offer| offer.id if  offer.orders_count_from_user(current_user) > 0 }.compact
  end

  def print_orders
    @offer = Offer.find(params[:id])
    @orders = @offer.orders.joins(:user).order("orders.delivery_id, users.name")    
  end

  def print_orders_per_item
    @offer = Offer.find(params[:id])
    @offer_items = @offer.offer_items
    @orders = @offer.orders.joins(:user).order("orders.delivery_id, users.name")
    @offer_items_sum = OfferItemOrders.new(@offer, @orders).get_sum_hash
  end

  def print_dispatch_notes
    @offer = Offer.find(params[:id])
    @orders = @offer.orders.joins(:user).order("orders.delivery_id, users.name")    
  end

  # GET /offers/1
  # GET /offers/1.json
  def show    
    @show_delete = (@offer.user == current_user)
    @my_orders = @offer.orders.where(user_id: current_user.id)
    @current_user_has_orders = @offer.orders_count_from_user(current_user) > 0
  end

  # GET /offers/new
  def new
    @offer = Offer.new
    @offer.offer_items.build #if @offer.offer_items.empty?
  end

  # GET /offers/1/edit
  def edit
    @offer.offer_items.build if @offer.offer_items.empty?
    @offer.deliveries.build if @offer.deliveries.empty?
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = Offer.new(offer_params.except(:attach))
    @offer.user = current_user
    
    respond_to do |format|
      if @offer.save && @offer.handle_attach(offer_params[:attach])
        format.html { redirect_to @offer, notice: 'Offer was successfully created.' }
        # format.json { render action: 'show', status: :created, location: @offer }
      else
        format.html { 
          @offer.offer_items.build
          @offer.deliveries.build
          render action: 'new' 
        }
        # format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update    
    respond_to do |format|      
      if @offer.update(offer_params.except(:attach)) and @offer.handle_attach(offer_params[:attach])
        
        format.html { 
          if params[:print_orders].present? 
            redirect_to print_orders_offer_path(@offer)
          elsif params[:print_dispatch_notes].present? 
            redirect_to print_dispatch_notes_offer_path(@offer)
          else
            flash[:notice] = 'Offer was successfully updated'
            if offer_params_include_total_available_qty?
              flash[:notice] += ' and orders quantity solidarized'
              redirect_to offer_orders_path(@offer)
            else
              redirect_to @offer
            end
          end
        }
        # format.json { head :no_content }
      else
        format.html { 
          if offer_params[:publishing_offer].present?
            render action: 'show'
          else
            render action: 'edit' 
          end
        }
        # format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def attach
    send_data(@offer.attach, type: @offer.attach_mime_type, disposition: "inline") if @offer.try(:attach)
  end
  
  def delete_attach
    @offer.attach = @offer.attach_mime_type = nil
    respond_to do |format|
      if @offer.save
        format.html { redirect_to @offer, notice: 'Offer was successfully updated.' }
        # format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        # format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer.destroy
    respond_to do |format|
      format.html { redirect_to my_offers_path }
      # format.json { head :no_content }
    end
  end

  def duplicate
    respond_to do |format|
      if @copy = @offer.duplicate
        format.html { redirect_to edit_offer_path(@copy), notice: 'Offer was successfully duplicated.' }
        # format.json { head :no_content }
      else
        format.html { redirect_to @offer, alert: 'Ooops, Offer was not duplicated due to error.' }
        # format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def deactivate
    @offer.deactivate
    @my_offers = current_user.offers.order('updated_at DESC')
    if params[:admin] == "offers"
      redirect_to admin_offers_path, notice: "Ponuda je deaktivirana"
    else
      redirect_to my_offers_path, notice: "Ponuda je deaktivirana"
    end
  end
  
  # GET /my_offers
  def my_offers
    @my_offers = current_user.offers.order('updated_at DESC').page(params[:page]).per(10)
  end
  
  # GET /admin_orders
  def admin
    @offers = Offer.order('id DESC').page(params[:page]).per(10)
  end
  
  def message_to_orderers
    message = Message.new(params[:message])
    
    if message.valid?
      NotificationsMailer.message_to_orderers(current_user, @offer, message).deliver
      redirect_to(offer_orders_path(@offer), notice: "Message was successfully sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :index
    end
  end
  
  private
  
  def offer_params_include_total_available_qty?
    offer_params && offer_params["offer_items_attributes"] && offer_params["offer_items_attributes"].map{|k1,v1| v1.map{|k2,v2| k2}}.flatten.include?("total_available_qty")
  end
  
  def offer_from_current_user?
    current_user.offers.exists?(id: params[:id])
  end
  
  def group_offerings_valid_for_current_user?
    current_user.group.group_offerings.exists?(offer_id: params[:id]) || current_user.admin || current_user.offers.exists?(id: params[:id])
  end
  
  def current_user_can_publish_offer
    if current_user.try(:group).blank? || !current_user.is_producer
      raise "[OffersController#current_user_can_publish_offer]"
    end
  end
  
  def current_user_can_write
    raise "[OffersController#current_user_can_write]" unless offer_from_current_user?
  end

  def current_user_can_read
    raise "[OffersController#current_user_can_read]" unless group_offerings_valid_for_current_user?
  end
  
  def current_user_is_admin
    raise "[OffersController#current_user_is_admin]" unless current_user.admin
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_offer
    @offer = Offer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def offer_params
    offer_item_fields = [:id, :_destroy, :position,  :title, :unit, :decimal_price, :note, :packaging, :total_available_qty, :status, :min_qty_per_order, :packaging_description, :unit_bulk, :decimal_price_bulk, :unit_package, :decimal_price_package, :unit_vario, :decimal_price_vario]
    delivery_fields = [:id, :_destroy, :location_id, :when]
    
    params.require(:offer).permit(:user_id, :title, :note, :publishing_offer, :valid_from, :valid_until, :delivered_at, :status, :company_name, :company_address, :company_oib, :dispatch_place, :dispatch_date, :attach, { group_ids: [] }, 
      offer_items_attributes: offer_item_fields, offer_items: offer_item_fields, 
      deliveries: delivery_fields, deliveries_attributes: delivery_fields)
  end

end
