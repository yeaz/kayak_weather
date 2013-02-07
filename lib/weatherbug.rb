require 'httparty'
require 'rubygems'

class Weatherbug 
  include HTTParty
  base_uri 'http://i.wxbug.net'
  
  API_KEYS = ['hm9jtjrw5q3b6f95rj4kcpcz', 
             's5ud8b4gw5ufatuktycbf4uz', 
             '9xkqb2g2m6hphbusuvhu5qpg',
             '2mjgqssbb3epdq2gh4r9c2km',
             'j6m4tk9hs4f682egneujdu83',
             'vtnmenqmvqryjuswwe7ptcdc',
             'em5vjqu3xxf9p63b2zwyjc7n',
             'dvdkjwc7rr5py8632efe39t5',
             'hx95um8hc5z2fuxnpuhqf2e7',
             'a5xpmr86e5apeb3qs46qbh5z',]
               
  def self.getForecast(la, lo, i)               
    get('/REST/Direct/GetForecast.ashx?la=' + la + '&lo=' + lo + '&nf=7&ht=t&l=en&c=US&api_key=' + API_KEYS[i])
  end

  def self.rating_restricted(body)
    body == '<h1>Developer Over Qps</h1>'
  end
  
end

