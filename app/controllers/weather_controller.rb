class WeatherController < ApplicationController
  
  #
  # Method: get_hot_spots
  # -------------------------------------------------
  # Returns the top ten hot spots from the origin and
  # distance requested.
  #
  def get_hot_spots
    
    @hot_spots = []
    @origin = Place.find(params[:place])
    @distance = params[:distance]
    
    # GET PLACES WITHIN REQUESTED DISTANCE FROM ORIGIN
    
    places = []
    if params[:geonamesAPI] == 'true'
      ##   USE GEONAMES API   ##
      rad = (@distance.to_i * 1.60934).to_s # Converting miles to kilometers
      geoResponse = Geonames.getPlaces(@origin.lat, @origin.lng, rad, "1000")
      geoList = geoResponse['geonames']
      
      # SAMPLING (DETERMINISTIC, EVEN DISTRIBUTION)
      numGeos = geoList.length
      limit = 100
      
      # Checks if number of returned places is large
      if numGeos > limit
        c = (numGeos*1.0)/limit
        for i in 0..(limit-1)
          index = (c*i).to_i # Index for sampled place
          gn = geoList[index]
          places << Place.new(name: gn['name'], lat: gn['lat'].to_s, lng: gn['lng'].to_s)
        end
      else 
        for gn in geoList
          places << Place.new(name: gn['name'], lat: gn['lat'].to_s, lng: gn['lng'].to_s)
        end
      end
    else
      ##   USE DATABASE   ##
      places << @origin
      distances = Distance.where('origin_id = ? AND value <= ?', @origin, @distance)
      for d in distances
        places << d.destination
      end
    end

    # GET 7-DAY FORECASTS FOR ALL PLACES
    
    forecasts = []
    id = 0 # API KEY ID - Used to alternate between multiple api keys to reduce response time
    for p in places
      fcResponse = Weatherbug.getForecast(p.lat, p.lng, id)
      fcList = fcResponse['forecastList']
      id = (id + 1) % 8
      for fc in fcList
        if !fc['high'].blank?
          forecasts << Forecast.new(p.name, p.lat, p.lng, fc['dateTime'], fc['high'].to_i)
        end
      end
    end
    
    # GET TOP 10 HOT SPOTS
    
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
    
    # SORT HOT SPOTS
    
    @hot_spots.sort! { |x, y| y <=> x }

    respond_to do |format|
      format.js
    end
    
  end
  
  #
  # Method: get_city_latlng
  # -------------------------------------------------
  # Returns the latitude and longitude of requested city
  # in JSON. Used for Google Map city marker positioning.
  #
  def get_city_latlng
    
    city = Place.find(params[:id])
    latlng = {lat: city.lat.to_f, lng: city.lng.to_f}
    respond_to do |format|
      format.json { render json: latlng }
    end
    
  end
  
  private 
  
    #
    # Method: get_ith_warmest
    # -------------------------------------------------
    # Implementation of the worst-case O(n) median of medians
    # selection algorithm. It selects the ith warmest forecast
    # in an unsorted array. ( i = 10 in our case )
    #
    def get_ith_warmest(array, i)
      # Base case
      if array.length <= 5
        array.sort! { |x, y| y <=> x }
        array[i-1]
      else
        median = get_median(array)
        low = []
        high = []
        
        # Partitioning array based on median-of-medians
        for elem in array
          if elem < median
            low << elem
          elsif elem > median
            high << elem
          end
        end
        
        # Recursive call         
        k = high.length + 1 # k is the rank of median-of-medians 
        if i > k
          get_ith_warmest(low, i - k) 
        elsif i < k
          get_ith_warmest(high, i)
        else
          median
        end
      end
    end
    
    #
    # Method: get_median
    # -------------------------------------------------
    # Helper method for getting the median of an unsorted
    # array. It divides the array into subsets of 5 elements
    # each, computes the medians of those subsets, and recursively
    # gets the median of those medians.
    #
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
