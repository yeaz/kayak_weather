import java.io.*;
import java.util.*;
import java.util.regex.*;
import java.lang.Math;

public class CityParser {

  public static City getCity(String tokens[]) { 
    int i = 2;
    int numTokens = tokens.length;
    
    String name = tokens[1];
    String state = "";
    double lat = 0.0;
    double lng = 0.0;
    
    ArrayList<String> nameParts = new ArrayList<String>();
    nameParts.add(tokens[1]);
    while (i < numTokens && !nameParts.contains(tokens[i]) && !tokens[i].matches("-?\\d+\\.\\d+")) {
      name += " " + tokens[i];
      nameParts.add(tokens[i]);
      i++;
    }
    
    while (i < numTokens) { 
      if (tokens[i].matches("-?\\d+\\.\\d+")) { 
        lat = Double.parseDouble(tokens[i]);
        lng = Double.parseDouble(tokens[i+1]);
        i += 2;
        break;
      }
      i++;
    }
    
    while (i < numTokens) { 
      if (tokens[i].equals("US")) { 
        state = tokens[i+1];
        break;
      }
      i++;
    }
  
    return new City(name, state, lat, lng);
  } 

  public static void main(String args[]) throws IOException { 
      
    ArrayList<City> cities = new ArrayList<City>();
    int numCities = 0;
    
    String readPath = "cities15000.txt";
    String writePath = "seeds.rb";
    BufferedReader br = new BufferedReader(new FileReader(new File(readPath)));
    BufferedWriter bw = new BufferedWriter(new FileWriter(new File(writePath)));
    
    String line;
    while((line = br.readLine()) != null) { 
      Pattern usCity = Pattern.compile("\\s+US\\s+");
      Matcher matcher = usCity.matcher(line);
      if (matcher.find()) {
        String tokens[] = line.split("\\s+");
        int numTokens = tokens.length;
        int i = numTokens - 1;
        
        while (i > 0) { 
          if (tokens[i].matches("\\d{5,}")) { 
            int population = Integer.parseInt(tokens[i]);
            if (population > 100000) { 
              City city = getCity(tokens);
              String cityOutputLine = "City.create(name: '" + city.getName() + "', state: '" + city.getState() + "', lat: '" + city.getLat() + "', lng: '" + city.getLng() + "')\n";
              bw.write(cityOutputLine);
              cities.add(city);
              numCities++;
            }
            break;
          }
          i--;
        } 
      }
    }
    
    City org, dest;
    for (int j = 0; j < numCities; j++) { 
      org = cities.get(j);
      for (int k = 0; k < numCities; k++) { 
        if (j != k) {
          dest = cities.get(k);
          int distance = org.distanceFrom(dest);
          String distanceOutputLine = "Distance.create(city_id: " + (j + 1) + ", destination_id: " + (k + 1) + ", value: " + distance + ")\n";
          bw.write(distanceOutputLine);
        }
      }
    }
    
    br.close();
    bw.close();
    
  }
}
