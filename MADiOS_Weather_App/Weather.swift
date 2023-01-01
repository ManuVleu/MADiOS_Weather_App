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


    init(localtime: String,temperature: Float,condition: String,windKpH: Float,windDirection:String,humidityPerc:Float,cloudPerc:Float) {
        self.localtime = localtime
        self.temperature = temperature
        self.condition = condition
        self.windKpH = windKpH
        self.windDirection = windDirection
        self.humidityPerc = humidityPerc
        self.cloudPerc = cloudPerc
    }

    func toString() {
        var weatherStr = ""
        weatherStr += "Weather on \(self.localtime) localtime\n"
        weatherStr += "Temperature: \(self.temperature) °C\n"
        weatherStr +="Wind speed: \(self.windKpH) kph\n"
        weatherStr +="Wind direction: \(self.windDirection)\n"
        weatherStr +="Humidity: \(self.humidityPerc) %\n"
        weatherStr +="Cloud: \(self.cloudPerc) %\n"
        weatherStr += "Condition: \(self.condition)\n"
        return weatherStr
    }

}
