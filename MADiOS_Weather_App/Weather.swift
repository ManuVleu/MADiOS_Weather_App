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
