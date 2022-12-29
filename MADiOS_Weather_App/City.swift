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
        fetchWeather(for: self) { result in
        switch result {
        case .success(let weather):
            print(weather)
            return weather
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            return "Error: \(error.localizedDescription)"
            }
        }

    }
}
