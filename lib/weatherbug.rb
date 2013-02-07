require 'httparty'
require 'rubygems'

class Weatherbug 
  include HTTParty
  format :json
  base_uri 'http://i.wxbug.net'
  
  API_KEYS = ['s5ud8b4gw5ufatuktycbf4uz', 'fbzpn6ambx9de5nusf49rv4d']
  
              
  def self.getForecast(la, lo, i)
    invalid = true               
    while invalid do
      response = get('/REST/Direct/GetForecast.ashx?la=' + la + '&lo=' + lo + '&nf=7&ht=t&l=en&c=US&api_key=' + API_KEYS[i])
      invalid = response.body.include?('<h1>Developer')
      puts i.to_s + " " + response.header
      sleep 0.5 if invalid
    end
    response
  end

end

