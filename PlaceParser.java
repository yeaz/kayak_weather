import java.io.*;
import java.util.*;
import java.util.regex.*;
import java.lang.Math;

public class PlaceParser {

  /* 
   * Method: getPlace
   * -------------------------------------------
   * Parses the tokens split from a line from the 
   * source file to obtain name, latitude, and longitude
   * of the corresponding US city. Returns a Place instance
   * containing the city data.
   */
  public static Place getPlace(String tokens[]) { 
    
    // Data variables
    String name = tokens[1];
    double lat = 0.0;
    double lng = 0.0;
    
    int i = 2 // Current token id (skips 0, 1 because it is unnecessary)
    int numTokens = tokens.length;
    
    
    /* NAME PARSING */
    ArrayList<String> nameParts = new ArrayList<String>();
    nameParts.add(tokens[1]);
    // Concates parts of city name together until it reaches start of different data section
    while (i < numTokens && !nameParts.contains(tokens[i]) && !tokens[i].matches("-?\\d+\\.\\d+")) {
      name += " " + tokens[i];
      nameParts.add(tokens[i]);
      i++;
    }
    
    /* LATITUDE, LONGITUDE PARSING */
    while (i < numTokens) { 
      if (tokens[i].matches("-?\\d+\\.\\d+")) { 
        lat = Double.parseDouble(tokens[i]);
        lng = Double.parseDouble(tokens[i+1]);
        i += 2;
        break;
      }
      i++;
    }
    
    /* STATE PARSING */
    while (i < numTokens) { 
      if (tokens[i].equals("US")) { 
        name += ", " + tokens[i+1]; // Concats state to end of city name
        break;
      }
      i++;
    }
  
    return new Place(name, lat, lng);
  } 

  /* MAIN FUNCTION */
  public static void main(String args[]) throws IOException { 
    
    ArrayList<Place> cities = new ArrayList<Place>();
    int numCities = 0;
    
    String readPath = "cities15000.txt"; // INPUT FILE
    String writePath = "seeds.rb";       // OUTPUT FILE
    BufferedReader br = new BufferedReader(new FileReader(new File(readPath)));
    BufferedWriter bw = new BufferedWriter(new FileWriter(new File(writePath)));
    
    /* CITIES OUTPUT */
    String line;
    while((line = br.readLine()) != null) { 
      // Checks that the city in the line is a US city
      Pattern usCity = Pattern.compile("\\s+US\\s+");
      Matcher matcher = usCity.matcher(line)
      if (matcher.find()) {
        // Splits line into tokens based on space character
        String tokens[] = line.split("\\s+");
        int numTokens = tokens.length;
        int i = numTokens - 1;
        
        // Finds population size of city and checks if it is over 100K
        while (i > 0) { 
          if (tokens[i].matches("\\d{5,}")) { 
            int population = Integer.parseInt(tokens[i]);
            if (population > 100000) {
              // Parses city data and outputs a command line for Rails database seeding
              Place city = getPlace(tokens);
              String cityOutputLine = "Place.create(name: '" + city.getName() + "', lat: '" + city.getLat() + "', lng: '" + city.getLng() + "')\n";
              bw.write(cityOutputLine);
              cities.add(city);
              numCities++;
            }
            break;
          }
          i--; // Checks from the last token because population data is located at the end of line
        } 
      }
    }
    
    /* DISTANCES OUTPUT */
    Place org, dest;
    for (int j = 0; j < numCities; j++) { 
      org = cities.get(j);
      for (int k = 0; k < numCities; k++) { 
        if (j != k) {
          dest = cities.get(k);
          int distance = org.distanceFrom(dest);
          String distanceOutputLine = "Distance.create(origin_id: " + (j + 1) + ", destination_id: " + (k + 1) + ", value: " + distance + ")\n";
          bw.write(distanceOutputLine);
        }
      }
    }
    
    br.close();
    bw.close();
    
  }
}
