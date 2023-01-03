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
        
        let label = UILabel()
        label.text = "Welcome to \(city.name)"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
