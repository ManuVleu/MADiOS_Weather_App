
func fetchWeather(for city: City,completion: @escaping (Result<Void, Error>) -> Void) {
    if let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"),
    let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
    let apiKey = dict["WeatherAPIKey"] as? String
    }
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
            let weatherData = try JSONDecoder().decode(Weather.self, from: data)
            print(weatherData)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }.resume()

    return weatherData
}