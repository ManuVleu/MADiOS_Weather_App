import Foundation
import UIKit

func fetchWeather(for city: City) -> Result<Weather, Error> {
    let apiKey = "50733048078f462e8fa115246220304"
    let urlString = "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&g=\(city.name)&days=5&aqi=yes&alerts=no"
    guard let url = URL(string: urlString) else {
        return .failure("Invalid URL" as! Error)
    }
    
    let semaphore = DispatchSemaphore(value: 0)

    var result: Result<Weather, Error>!
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            result = .failure(error)
        } else {
            do {
                let weatherData = try JSONDecoder().decode(WeatherJSON.self, from: data)
                print(weatherData)
                result = .success(weatherData)
            } catch {
                result = .failure(error)
            }
        }
        semaphore.signal()
        
    }.resume()

    semaphore.wait()
    return result
}

struct WeatherJSON: Decodable {
    let current: Current
    let location: Location
    
    struct Location: Decodable {
        let localtime: String
    }
    
    struct Current: Decodable {
        let temp_c: Float
        let condition: NSCondition
        let wind_kph: Float
        let wind_dir: String
        let humidity: Int
        let cloud: Int
        
        struct Condition: Decodable {
            let text: String
            let icon: String
        }
    }
    //if attribute names differ from the JSON names gebruik CodingKeys
    
    
}
