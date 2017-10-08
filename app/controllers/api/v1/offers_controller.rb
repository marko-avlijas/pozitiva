class Api::V1::OffersController < Api::V1::ApiController

  def index
    offers = current_user.offers
    # valid_from = DateTime.parse(params[:from]) if params[:from]
    # offers     = offers.where("offers.valid_from >= ?", valid_from) if valid_from
    limit = params.fetch(:limit, 100).to_i
    limit =  100 if limit == 0
    limit = 1000 if limit > 1000
    @offers = offers.includes(:user, { deliveries: :location }).order(id: :desc).limit(limit)
  end

  def selected_with_orders
    offer_ids = params[:ids].to_s.split(',')
    @offers   = current_user.offers.where(id: offer_ids).includes(
      { orders: [{ user: :group }, { order_items: :offer_item }] },
      { deliveries: :location }
    ).order(id: :desc)
  end

end
