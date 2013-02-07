class WeatherController < ApplicationController
  
  def get_hot_spots
    
    @hot_spots = []
    @place = Place.find(params[:place])
    @distance = params[:distance]
    geonames_api = params[:geonamesAPI] == 'true'
    
    places = []
    if geonames_api
      rad = (@distance.to_i * 1.60934).to_s
      geoResponse = Geonames.getPlaces(@place.lat, @place.lng, rad, "1000")
      geoList = geoResponse['geonames']
      for gn in geoList
        places << Place.new(name: gn['name'] + ", " + gn['adminCode1'], lat: gn['lat'].to_s, lng: gn['lng'].to_s)
      end
    else
      places << @place
      distances = Distance.where('origin_id = ? AND value <= ?', @place, @distance)
      for d in distances
        places << d.destination
      end
    end

    forecasts = []
    id = 0
    for p in places
      id = (id + 1) % 30
      fcResponse = Weatherbug.getForecast(p.lat, p.lng, id)
      fcList = fcResponse['forecastList']
      
      for fc in fcList
        if !fc['high'].blank?
          forecasts << Forecast.new(p.name, p.lat, p.lng, fc['dateTime'], fc['high'].to_i)
        end
      end
    end
    
    if forecasts.length > 10
      tenth = get_ith_warmest(forecasts, 10)
      for f in forecasts
        if f >= tenth
          @hot_spots << f
        end
      end 
    else
      for f in forecasts
        @hot_spots << f
      end
    end
    
    @hot_spots.sort! { |x, y| y <=> x }

    respond_to do |format|
      format.js
    end
    
  end
  
  def get_city_latlng
    
    city = Place.find(params[:id])
    latlng = {lat: city.lat.to_f, lng: city.lng.to_f}
    respond_to do |format|
      format.json { render json: latlng }
    end
    
  end
  
  private 
  
    def get_ith_warmest(array, i)
      numElems = array.length
      if numElems <= 5
        array.sort! { |x, y| y <=> x }
        array[i-1]
      else
        median = get_median(array)
        low = []
        high = []
        for elem in array
          if elem < median
            low << elem
          elsif elem > median
            high << elem
          end
        end
                
        k = high.length + 1
        if i > k
          get_ith_warmest(low, i - k) 
        elsif i < k
          get_ith_warmest(high, i)
        else
          median
        end
        
      end
    end
    
    def get_median(array)
      numElems = array.length
      if numElems <= 5
        array.sort! { |x, y| y <=> x }
        array[((numElems+1)/2) - 1]
      else 
        medians = []
        index = 0
        while index < numElems do
          set = []
          count = (numElems - index >= 5) ? 5 : numElems - index 
          count.times { |j| set << array[index + j] }
          set.sort! { |x, y| y <=> x }
          medians << set[((count+1)/2) - 1]
          index += count
        end
        get_median(medians)
      end
    end
    
end
