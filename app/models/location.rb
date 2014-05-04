class Location < ActiveRecord::Base
  has_many :deliveries, inverse_of: :location, dependent: :restrict_with_error # don't delete location if offer delivery exists
  has_many :offers, through: :deliveries
  
  def map_url
    # "http://mygeoposition.com/?q=#{delivery.location.lat},#{delivery.location.lng}"
    # "http://www.openstreetmap.org/#map=17/#{lat}/#{lng}"
    # "http://www.openstreetmap.org/?mlat=45.77876&mlon=15.98270#map=17/45.77876/15.98270"
    "http://www.openstreetmap.org/?mlat=#{lat}&mlon=#{lng}#map=17/#{lat}/#{lng}" if lat? && lng?
  end
  
  def iframe_src
    # http://www.openstreetmap.org/export/embed.html?bbox=15.9427%2C45.75376%2C16.0227%2C45.78126&amp;layer=mapnik&amp;marker=45.77876%2C15.9827
    "http://www.openstreetmap.org/export/embed.html?bbox=#{lng.to_d+0.06}%2C#{lat.to_d+0.025}%2C#{lng.to_d-0.06}%2C#{lat.to_d-0.0025}" + 
      "&amp;layer=mapnik&amp;marker=#{lat}%2C#{lng}" if lat? && lng?
  end
end
