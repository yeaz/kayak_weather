import java.lang.Math;

public class City {

  private String name;
  private String state;
  private double lat;
  private double lng;
  
  public City(String c_name, String c_state, double c_lat, double c_lng) {
    name = c_name;
    state = c_state;
    lat = c_lat;
    lng = c_lng;
  }
  
  public int distanceFrom(City city) { 
    double dlng = Math.toRadians(lng - city.lng);
    double dlat = Math.toRadians(lat - city.lat);
    double lat1 = Math.toRadians(lat);
    double lat2 = Math.toRadians(city.lat);
    double a = (Math.sin(dlat/2))*(Math.sin(dlat/2)) + Math.cos(lat1) * Math.cos(lat2) * (Math.sin(dlng/2)) * (Math.sin(dlng/2));
    double c = 2 * (Math.atan2( Math.sqrt(a), Math.sqrt(1-a) ));
    double distance = 3961 * c;
    return (int) distance;
  }
  
  public String getName() {
   return name;
  }
  
  public String getState() {
   return state;
  }
  
  public double getLat() {
   return lat;
  }
  
  public double getLng() {
   return lng;
  }
  
}
