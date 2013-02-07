require 'httparty'
require 'rubygems'

class Weatherbug 
  include HTTParty
  format :json
  base_uri 'http://i.wxbug.net'
  
  API_KEYS = ['hm9jtjrw5q3b6f95rj4kcpcz', 's5ud8b4gw5ufatuktycbf4uz', 
              '9xkqb2g2m6hphbusuvhu5qpg', '2mjgqssbb3epdq2gh4r9c2km',
              'j6m4tk9hs4f682egneujdu83', 'vtnmenqmvqryjuswwe7ptcdc',
              'em5vjqu3xxf9p63b2zwyjc7n', 'dvdkjwc7rr5py8632efe39t5',
              'hx95um8hc5z2fuxnpuhqf2e7', 'a5xpmr86e5apeb3qs46qbh5z',
              'fbzpn6ambx9de5nusf49rv4d', '8793wwa6j6jx975aerzmuxpx',
              '8zznshshg5vqrbrejy6hd5z3', '8jeeb9r79s4n3m8yau6ycv7z',
              'ncsh5zjxmzv256m5vnjjykgq', 'zftptzq3twpvv6eywkpz4hjt',
              'tt8emhdddzf4m8trv39fkc88', 'ntx37en6bsh5xmqj64azd2yq',
              'd38vtdhnjucv33ramjxka35k', 'txf43p7kswny48rgqumpmj5s',
              'jfv592mhmj6p3h3nv6ne6v4r', 'n3b2e8a9tg2ygcwab2yrjjgz',
              'czv4rcxejqb93sue3wwkp8gd', 'c89vu53a3fzug8xnzg867x37',
              'ynge2fe8hnxah5j2qvwxhkku', '9h7hkfyef8ryvxs37kankd4t',
              '77r6e6jyfqsn86k6drh3t4g7', 'xdm49uq649k9fewgvf82453r',
              'kayqn5pvjyr74kwyzvcbnms6', 'dftac6f2dg5wesrhqv96yrq2']
  
              
  def self.getForecast(la, lo, i)
    id = i
    invalid = true               
    while invalid do
      response = get('/REST/Direct/GetForecast.ashx?la=' + la + '&lo=' + lo + '&nf=7&ht=t&l=en&c=US&api_key=' + API_KEYS[id])
      invalid = response.body.include?('Developer')
      puts id if invalid
      id = (id + 1) % 30
    end
    response
  end

end

