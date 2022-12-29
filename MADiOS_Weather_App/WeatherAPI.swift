import Foundation

func fetchWeather(for city: City) {
    let apiKey = "50733048078f462e8fa115246220304"
    let urlString = "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&g=\(city.name)&days=5&aqi=yes&alerts=no"
    guard let url = URL(string: urlString) else {
        completion(.failure(APIError.invalidURL))
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        do {
            let weatherData = try JSONDecoder().decode(Any.self, from: data)
            print(weatherData)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }.resume()

    return weatherData
}
