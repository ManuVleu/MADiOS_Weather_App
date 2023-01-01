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
    let region: String
    let country: String
    
    let weather: Weather
    
    init(name: String, region: String, country: String) {
        self.name = name
        self.region = region
        self.country = country
    }

   func setWeather(weather: Weather) {
        self.weather = weather
   }

    func toString(){
        var cityStr = ""
        cityStr += "City: \(self.name)\n"
        cityStr += "Region: \(self.region), \(self.country)\n"
        city += self.weather.toString()
        return cityStr
    }

}
