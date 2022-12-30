//
//  City.swift
//  MADiOS_Weather_App
//
//  Created by Manu Vleurick on 28/12/2022.
//

import UIKit
import Foundation

class City {
    let name: String
    let weatherData: [Weather] = []//Lijst van weather objecten voor elke dag
    
    init(name: String) {
        self.name = name
    }

    // TODO set attributes to data gathered
    func setWeatherData(completion: @escaping (Result<[Weather],Error>) -> Void) async {
        let res = await fetchWeather(for: self)
        print(res)
        
    }
}
