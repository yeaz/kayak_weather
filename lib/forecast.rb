class Forecast
  include Comparable
  attr_reader :lat, :lng, :loc, :dateTime, :temp
  def initialize(lat, lng, loc, dateTime, temp)
    @lat = lat
    @lng = lng
    @loc = loc
    @dateTime = dateTime
    @temp = temp
  end
 
  def <=>(another_forecast)
    if self.temp < another_forecast.temp
      -1
    elsif self.temp > another_forecast.temp
      1
    else
      if self.loc > another_forecast.loc
        -1
      elsif self.loc < another_forecast.loc
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
