import java.lang.Math;

public class Place {

  private String name;
  private double lat;
  private double lng;
  
  /* CONSTRUCTOR METHOD */
  public Place(String p_name, double p_lat, double p_lng) {
    name = p_name;
    lat = p_lat;
    lng = p_lng;
  }
  
  /* 
   * Method: distanceFrom
   * -------------------------------------------
   * Computes the distance between two places in
   * miles, using their latitudes and longitudes.
   */
  public int distanceFrom(Place place) { 
    double dlng = Math.toRadians(lng - place.lng);
    double dlat = Math.toRadians(lat - place.lat);
    double lat1 = Math.toRadians(lat);
    double lat2 = Math.toRadians(place.lat);
    double a = (Math.sin(dlat/2))*(Math.sin(dlat/2)) + Math.cos(lat1) * Math.cos(lat2) * (Math.sin(dlng/2)) * (Math.sin(dlng/2));
    double c = 2 * (Math.atan2( Math.sqrt(a), Math.sqrt(1-a) ));
    double distance = 3961 * c;
    return (int) distance;
  }
  
  /* 
   * Method: getName
   * -------------------------------------------
   * Returns name of place.
   */
  public String getName() {
   return name;
  }
  
  /* 
   * Method: getLat
   * -------------------------------------------
   * Returns latitude of place.
   */
  public double getLat() {
   return lat;
  }
  
  /* 
   * Method: getLng
   * -------------------------------------------
   * Returns longitude of place.
   */
  public double getLng() {
   return lng;
  }
  
}
