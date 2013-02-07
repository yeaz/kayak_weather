require 'httparty'
require 'rubygems'

class Weatherbug 
  include HTTParty
  format :json
  base_uri 'http://i.wxbug.net'
  
  API_KEYS = ['s5ud8b4gw5ufatuktycbf4uz', 'fbzpn6ambx9de5nusf49rv4d']
  
              
  def self.getForecast(la, lo, i)
    id = i
    invalid = true               
    while invalid do
      response = get('/REST/Direct/GetForecast.ashx?la=' + la + '&lo=' + lo + '&nf=7&ht=t&l=en&c=US&api_key=' + API_KEYS[id])
      invalid = response.body.include?('<h1>Developer')
      puts id.to_s + " " + response.header if invalid
      id = (id + 1) % 2
    end
    response
  end

end

