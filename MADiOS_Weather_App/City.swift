//
//  City.swift
//  MADiOS_Weather_App
//
//  Created by Manu Vleurick on 28/12/2022.
//

import UIKit
import WeatherAPI

class City {
    let name: String
    let weatherData: [Weather]()//Lijst van weather objecten voor elke dag
    

    init(name: String,weatherIcon: UIImage = UIImage(systemName: "cloud.sun.fill") {
        self.name = name
        self.weatherIcon = weatherIcon
        setWeatherData()
    }

    // TODO set attributes to data gathered
    func setWeatherData() {
        fetchWeather(for: city) { result in
        switch result {
        case .success(let weather):
            print(weather)
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            }
        }

        print(data)
    }
}
