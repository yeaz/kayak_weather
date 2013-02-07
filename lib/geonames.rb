require 'httparty'
require 'rubygems'

class Geonames
  include HTTParty
  format :json
  base_uri 'http://ws.geonames.net'
  
  USERNAME = 'ms_test201302'
               
  def self.getPlaces(lat, lng, rad, rows)
    get('/findNearbyPlaceNameJSON?lat=' + lat + '&lng=' + lng + '&radius=' + rad + '&maxRows=' + rows + '&username=' + USERNAME )
  end

end
