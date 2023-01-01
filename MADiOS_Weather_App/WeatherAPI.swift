import Foundation
import UIKit

func fetchWeather(for city: City) -> Result<WeatherJSON, Error> {
    let apiKey = "50733048078f462e8fa115246220304"
    let urlString = "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&g=\(city.name)&days=5&aqi=yes&alerts=no"
    guard let url = URL(string: urlString) else {
        return .failure("Invalid URL" as! Error)
    }
    
    let semaphore = DispatchSemaphore(value: 0)

    var result: Result<WeatherJSON, Error>!
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            result = .failure(error)
        } else {
            do {
                if let data = data {
                    let weatherData = try JSONDecoder().decode(WeatherJSON.self, from: data)
                    print(weatherData)
                    result = .success(weatherData)
                } else {
                    result = .failure("No data returned from the server" as! Error)
                }
                
            } catch {
                result = .failure(error)
            }
        }
        semaphore.signal()
        
    }.resume()

    semaphore.wait()
    if let result = result {
        let anyRes = result as Any
        print(anyRes)
    }
    return result
}



