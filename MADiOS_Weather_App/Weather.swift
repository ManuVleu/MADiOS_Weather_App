import UIKit
import Foundation

class Weather {
    let localtime: String
    let temperature: Float
    let condition: String
    let windKpH: Float
    let windDirection: String
    let humidityPerc: Float
    let cloudPerc: Float

    init() {
        self.localtime = ""
        self.temperature = 0.0
        self.condition = ""
        self.windKpH = 0.0
        self.windDirection = ""
        self.humidityPerc = 0.0
        self.cloudPerc = 0.0
    }

    init(localtime: String,temperature: Float,condition: String,windKpH: Float,windDirection:String,humidityPerc:Float,cloudPerc:Float) {
        self.localtime = localtime
        self.temperature = temperature
        self.condition = condition
        self.windKpH = windKpH
        self.windDirection = windDirection
        self.humidityPerc = humidityPerc
        self.cloudPerc = cloudPerc
    }
    
    func getConditionIconName() -> String {
        let condition: String = self.condition.lowercased()
        
        if condition.contains("sunny") || condition.contains("clear") {
            return "sun.max"
        } else if condition.contains("cloudy") || condition.contains("overcast") {
            return "cloud"
        } else if condition.contains("mist") || condition.contains("fog") {
            return "cloud.fog"
        } else if condition.contains("rain") {
            return "cloud.rain"
        } else if condition.contains("snow") {
            return "cloud.snow"
        } else if condition.contains("blizzard") {
            return "wind.snow"
        } else if condition.contains("ice pellets") {
            return "snowflake"
        } else if condition.contains("rain") && condition.contains("thunder") {
            return "cloud.bolt.rain"
        } else if condition.contains("thunder") {
            return "cloud.bolt"
        } else if condition.contains("drizzle") {
            return "cloud.drizzle"
        } else if condition.contains("sleet") {
            return "cloud.sleet"
        }
        
        return "sun.min"
        
    }

    func toString() -> String {
        var weatherStr = ""
        weatherStr = weatherStr + "Weather on \(self.localtime) localtime\n"
        weatherStr = weatherStr + "Temperature: \(self.temperature) °C\n"
        weatherStr = weatherStr + "Wind speed: \(self.windKpH) kph\n"
        weatherStr = weatherStr + "Wind direction: \(self.windDirection)\n"
        weatherStr = weatherStr + "Humidity: \(self.humidityPerc) %\n"
        weatherStr = weatherStr + "Cloud: \(self.cloudPerc) %\n"
        weatherStr = weatherStr + "Condition: \(self.condition)\n"
        return weatherStr
    }

}
