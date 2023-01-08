

import Foundation

protocol CityViewControllerDelegate: AnyObject {
    func updateCities(_ cities: [City])
}
