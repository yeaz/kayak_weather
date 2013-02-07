require 'httparty'
require 'rubygems'

class Weatherbug 
  include HTTParty
  format :json
  headers 'Content-Type' => "application/json"
  headers 'Accepts' => "application/json"
  base_uri 'http://i.wxbug.net'

  def self.getForecast(la, lo, i)
    api_key = ['hm9jtjrw5q3b6f95rj4kcpcz', 
               's5ud8b4gw5ufatuktycbf4uz', 
               '9xkqb2g2m6hphbusuvhu5qpg',
               '2mjgqssbb3epdq2gh4r9c2km',
               'j6m4tk9hs4f682egneujdu83',
               'vtnmenqmvqryjuswwe7ptcdc',
               'em5vjqu3xxf9p63b2zwyjc7n',
               'dvdkjwc7rr5py8632efe39t5',
               'hx95um8hc5z2fuxnpuhqf2e7',
               'a5xpmr86e5apeb3qs46qbh5z',
               'fbzpn6ambx9de5nusf49rv4d']
               
    get('/REST/Direct/GetForecast.ashx?la=' + la + '&lo=' + lo + '&nf=7&ht=t&l=en&c=US&api_key=' + api_key[i])
  end

end

