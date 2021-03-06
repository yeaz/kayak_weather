require 'httparty'
require 'rubygems'

class Weatherbug 
  include HTTParty
  format :json
  base_uri 'http://i.wxbug.net'
  
  API_KEYS = ['s5ud8b4gw5ufatuktycbf4uz', 'ytdtfvxpxhg7x9ue2yckrgud',
              'tvyn6gea7shqgx8ktx9xy468', 'p9an88qhw8ey3vzasrddvz4y',
              '8ya4revzre2ztgzu2y3eauen', 'e2e4yqs9y64f2wz4h2j8syny',
              'yx3hhahxjpy4hkadygftu3ak', 'hw3j3ytke66kame8ng38bfdq']
  
              
  def self.getForecast(la, lo, i)
    id = i
    invalid = true               
    while invalid do
      response = get('/REST/Direct/GetForecast.ashx?la=' + la + '&lo=' + lo + '&nf=7&ht=t&l=en&c=US&api_key=' + API_KEYS[id])
      invalid = response.body.include?('<h1>Developer')
      id = (id + 1) % 8
    end
    response
  end

end

