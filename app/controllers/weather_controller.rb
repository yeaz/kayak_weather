class WeatherController < ApplicationController
  
  def get_hot_spots
    
    @hot_spots = []
    @city = City.find(params[:city])
    @radius = params[:radius]
    
    forecasts = []
    distances = Distance.where('city_id = ? AND value <= ?', @city, @radius)
    

    for distance in distances
      dest = distance.destination
      sleep 0.5 # Due to API QPS Restrictions
      puts Time.now
      response = Weatherbug.getForecast(dest.lat, dest.lng)
      cityForecasts = response['forecastList']
      
      for cf in cityForecasts
        if !cf['high'].blank?
          loc = dest.name + ", " + dest.state
          dateTime = cf['dateTime']
          temp = cf['high'].to_i
          forecasts << Forecast.new(dest.lat, dest.lng, loc, dateTime, temp)
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
    
    city = City.find(params[:id])
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
