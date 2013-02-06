KayakWeather::Application.routes.draw do
  
  root to: 'weather#index' 
  
  match 'get_hot_spots', to: 'weather#get_hot_spots', as: 'get_hot_spots'
  match 'get_city_latlng', to: 'weather#get_city_latlng', as: 'get_city_latlng'

end
