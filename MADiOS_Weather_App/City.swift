//
//  City.swift
//  MADiOS_Weather_App
//
//  Created by Manu Vleurick on 28/12/2022.
//

import UIKit

class City {
    let name: String
    let weatherData: [Weather] = []//Lijst van weather objecten voor elke dag
    
    init(name: String) {
        self.name = name
        setWeatherData()
    }

    // TODO set attributes to data gathered
    func setWeatherData() {
        let result = fetchWeather(for: self)
        switch result {
        case .success(let weatherJSON):
            let weather = Weather(datum: weatherJSON.location.localtime, temperature: weatherJSON.current.temp_c, conditionText: weatherJSON.current.condition.text, weatherIcon: weatherJSON.current.condition.icon, windKPH: weatherJSON.current.wind_kph, windDirection: weatherJSON.current.wind_dir, humidityPerc: weatherJSON.current.humidity, cloudPerc: weatherJSON.current.cloud)
            self.weatherData.append(weather)
        case .failure(let error):
            print("Failed to fetch weather: \(error)")
        }
    }
}
