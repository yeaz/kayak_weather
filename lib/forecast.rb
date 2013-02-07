class Forecast
  include Comparable
  attr_reader :name, :lat, :lng, :dateTime, :temp
  def initialize(name, lat, lng, dateTime, temp)
    @name = name
    @lat = lat
    @lng = lng
    @dateTime = dateTime
    @temp = temp
  end
 
  def <=>(another_forecast)
    if self.temp < another_forecast.temp
      -1
    elsif self.temp > another_forecast.temp
      1
    else
      if self.name > another_forecast.name
        -1
      elsif self.name < another_forecast.name
        1
      else
        if self.dateTime < another_forecast.dateTime
          -1
        elsif self.dateTime > another_forecast.dateTime
          1
        else
          0
        end
      end
    end
  end
end
