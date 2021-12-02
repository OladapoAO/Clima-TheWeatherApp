import Foundation

//Code used to Fetch Data from the Weather API

protocol WeatherManagerDelegate { //
    func didUpdateWeather(_ weaatherManager:WeatherManager, weather:WeatherModel)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=e9aba0a3b95b183ca083effc1b4b3849&units=metric"
    
    var delegate: WeatherManagerDelegate? //The delegate property of the Weather Manager allows us to access it in WeatherViewController
    
    func fetchWeather (cityname: String) {
        let urlString = "\(weatherURL)&q=\(cityname)"
        performRequest(with: urlString)
    }
    
    func performRequest (with urlString:String) {
        
        //1. Create a URL
           if let url = URL(string: urlString) { // A URL Object used to receive data from our webserver
            
        //2. Create a URL session
            let session = URLSession(configuration: .default) // The session is thing that performs the networking effectively acts like a browser
               
        //3. Give the session a task
               let task = session.dataTask(with: url) { (data, response, error ) in //This is a closure
                   
                   if error != nil {
                       print(error!)
                       return //Exit and don't continue
                   }
                   
                   if let safeData = data { //If we do get Data, it is safe so we want to do something and take  a look at it
                       if let weather =  self.parseJSON(safeData) {
                           self.delegate?.didUpdateWeather(self, weather:weather)
                       }
                   }
               
               }
               
          //4. Start the task
               task.resume()
      }
       
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do{
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = (decodedData.weather[0].id)
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
     
    
        } catch {
            print(error)
            return nil
        }
        
    }
    
  

}

