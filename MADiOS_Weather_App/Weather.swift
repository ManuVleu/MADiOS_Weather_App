import UIKit
import Foundation

class Weather {
    let datum: Date// yyyy/MM/dd
    let temperature: Float
    let conditionText: String
    let weatherIcon: UIImage
    let windKPH: Float
    let windDirection: String
    let humidityPerc: Float
    let cloudPerc: Float


    init(datum: Date,temperature: Float,conditionText: String,weatherIcon: UIImage,windKPH: Float,windDirection:String,humidityPerc:Float,cloudPerc:Float) {
        self.datum = datum
        self.temperature = temperature
        self.conditionText = conditionText
        self.weatherIcon = weatherIcon
        self.windKPH = windKPH
        self.windDirection = windDirection
        self.humidityPerc = humidityPerc
        self.cloudPerc = cloudPerc
    }

}
