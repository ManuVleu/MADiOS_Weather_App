//
//  CityViewController.swift
//  MADiOS_Weather_App
//
//  Created by Manu Vleurick on 03/01/2023.
//

import Foundation
import UIKit

class CityViewController: UIViewController {
    var city: City
    
    let cityLabel = UILabel()
    let regionLabel = UILabel()
    let countryLabel = UILabel()
    
    let timeLabel = UILabel()
    let tempLabel = UILabel()
    let conditionLabel = UILabel()
    let windkphLabel = UILabel()
    let windDirectionLabel = UILabel()
    let humidityLabel = UILabel()
    let cloudLabel = UILabel()
    
    
    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = city.name
        
        setupCityLabels()
        
        setupTempLabel()
        
        setupWeatherDetails()
    }
    
    func setupCityLabels() {
        
    }
}
