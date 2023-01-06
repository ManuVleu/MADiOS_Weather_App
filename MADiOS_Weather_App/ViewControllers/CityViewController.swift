//
//  CityViewController.swift
//  MADiOS_Weather_App
//
//  Created by Manu Vleurick on 03/01/2023.
//

import Foundation
import UIKit

class CityViewController: UIViewController {
    /*
     Vraag: Vanaf welke temperatuur begin je warm te krijgen?
     Persoon: "Dokter" Daan
     Date: 05/01/2023
     */
    let LAUWE_TEMP: Float = 23.0
    
    var city: City
    
    let favoriteButton = UIButton()
    
    let cityStackView = UIStackView()
    let regionCountryStackView = UIStackView()
    let conditionIcon = UIImageView()
    let cityLabel = UILabel()
    let regionLabel = UILabel()
    let countryLabel = UILabel()
    
    let weatherStackView = UIStackView()
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
        
        setupGradientBackground()
        
        title = city.name
        
        setupFavoriteButton()
        
        setupCityLabels()
        
        setupTempLabel()
        
        setupWeatherDetails()
    }
    
    func setupFavoriteButton() {
        view.addSubview(favoriteButton)
        
        // favoriteButton.setTitle("Favorite", for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        //constraints
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }
    
    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0,1]
        gradientLayer.frame = view.bounds
        
        
        if self.city.weather.temperature > self.LAUWE_TEMP {
            // Warm
            gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
            cityLabel.textColor = .darkGray
            regionLabel.textColor = .darkGray
            countryLabel.textColor = .darkGray
            tempLabel.textColor = .darkGray
            timeLabel.textColor = .darkGray
            conditionLabel.textColor = .darkGray
            windkphLabel.textColor = .darkGray
            windDirectionLabel.textColor = .darkGray
            humidityLabel.textColor = .darkGray
            cloudLabel.textColor = .darkGray
        } else {
            // Kou
            gradientLayer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
            cityLabel.textColor = .lightGray
            regionLabel.textColor = .lightGray
            countryLabel.textColor = .lightGray
            tempLabel.textColor = .lightGray
            timeLabel.textColor = .lightGray
            conditionLabel.textColor = .lightGray
            windkphLabel.textColor = .lightGray
            windDirectionLabel.textColor = .lightGray
            humidityLabel.textColor = .lightGray
            cloudLabel.textColor = .lightGray
        }
        
        view.layer.addSublayer(gradientLayer)
    }
    
    func setupCityLabels() {
        
        cityStackView.axis = .vertical
        cityStackView.alignment = .center
        cityStackView.distribution = .equalSpacing
        
        regionCountryStackView.axis = .horizontal
        regionCountryStackView.alignment = .center
        regionCountryStackView.distribution = .equalSpacing
        
        regionCountryStackView.addArrangedSubview(regionLabel)
        regionCountryStackView.addArrangedSubview(countryLabel)
        
        cityStackView.addArrangedSubview(conditionIcon)
        cityStackView.addArrangedSubview(cityLabel)
        cityStackView.addArrangedSubview(regionCountryStackView)
        cityStackView.addArrangedSubview(conditionLabel)
        view.addSubview(cityStackView)
        
        cityLabel.text = city.name
        if city.region == "" {
            regionLabel.text = ""
        } else {
            regionLabel.text = city.region + ", "
        }
        countryLabel.text = city.country
        conditionLabel.text = city.weather.condition
        
        cityLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        regionLabel.font = UIFont(name: "Avenir", size: 15)
        countryLabel.font = UIFont(name: "Avenir", size: 15)
        conditionLabel.font = UIFont(name: "Avenir", size: 20)
        
        // constraints
        cityStackView.translatesAutoresizingMaskIntoConstraints = false
        cityStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        conditionIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        conditionIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //conditionIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //conditionIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupTempLabel() {
        view.addSubview(tempLabel)
        tempLabel.text = "\(self.city.weather.temperature)°"
        tempLabel.font = UIFont.systemFont(ofSize: 35)
        
        //constraints
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.topAnchor.constraint(equalTo: cityStackView.bottomAnchor, constant: 75).isActive = true
        tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func setupWeatherDetails() {
        let systemName: String = self.getConditionIconName()
        conditionIcon.image = UIImage(systemName: systemName)
        
        weatherStackView.axis = .vertical
        weatherStackView.alignment = .fill
        weatherStackView.distribution = .equalSpacing
        
        weatherStackView.addArrangedSubview(timeLabel)
        weatherStackView.addArrangedSubview(windkphLabel)
        weatherStackView.addArrangedSubview(windDirectionLabel)
        weatherStackView.addArrangedSubview(humidityLabel)
        weatherStackView.addArrangedSubview(cloudLabel)
        
        view.addSubview(weatherStackView)
        
        timeLabel.text = "Local Time: \(city.weather.localtime)"
        windkphLabel.text = "Wind Speed: \(city.weather.windKpH) kpH"
        windDirectionLabel.text = "Wind Direction: \(city.weather.windDirection)"
        humidityLabel.text = "Humidity Percentage: \(city.weather.humidityPerc)%"
        cloudLabel.text = "Cloud Percentage: \(city.weather.cloudPerc)%"
        
        timeLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
        
        // constraints
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        windkphLabel.translatesAutoresizingMaskIntoConstraints = false
        windDirectionLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        cloudLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weatherStackView.topAnchor.constraint(equalTo: tempLabel.bottomAnchor,constant: 55).isActive = true
        
        windkphLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor,constant: 10).isActive = true
        
    }
    
    func getConditionIconName() -> String {
        let condition: String = self.city.weather.condition.lowercased()
        
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
            return "cloud.sleeet"
        }
        
        return "sun.min"
        
    }
    
    @objc func favoriteButtonTapped() {
        print("fav tapped")
    }
}
