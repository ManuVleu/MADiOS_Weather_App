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
    var region: String
    var country: String
    
    var weather: Weather
    
    init(name: String, region: String = "Unknown", country: String = "Unknown") {
        self.name = name
        self.region = region
        self.country = country
        self.weather = Weather()
    }
    
    func setRegion(region: String) {
        self.region = region
    }
    
    func setCountry(country: String) {
        self.country = country
    }

   func setWeather(weather: Weather) {
        self.weather = weather
   }

    func toString() -> String {
        var cityStr = ""
        cityStr = cityStr + "City: \(self.name)\n"
        cityStr = cityStr + "Region: \(self.region), \(self.country)\n"
        let weatherStr: String = self.weather.toString()
        cityStr = cityStr + weatherStr
        return cityStr
    }

}
