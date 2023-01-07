//
//  CityViewControllerDelegate.swift
//  MADiOS_Weather_App
//
//  Created by Manu Vleurick on 07/01/2023.
//

import Foundation

protocol CityViewControllerDelegate: AnyObject {
    func updateCities(_ cities: [City])
}
