require 'httparty'
require 'rubygems'

class Weatherbug 
  include HTTParty
  format :json
  base_uri 'http://i.wxbug.net'

  def self.getForecast(la, lo)
    api_key = 'hm9jtjrw5q3b6f95rj4kcpcz'
    get('/REST/Direct/GetForecast.ashx?la=' + la + '&lo=' + lo + '&nf=7&ht=t&l=en&c=US&api_key=' + api_key)
  end

end

