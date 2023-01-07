import UIKit
import Foundation
import SWXMLHash
import CoreLocation

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, UISearchResultsUpdating, UISearchBarDelegate, CityViewControllerDelegate {
    
    //executes evertime sometihing is typed in searchbar
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchBar.searchBar.text!
        //print(searchText)
    }
    
    // executed only when you Enter
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        self.getAPIData(cityName: searchText) {
            city in
            if let city = city {
                let cityVC = CityViewController(city: city, cities: self.cities)
                cityVC.delegate = self
                // self.cities.append(city)
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = true
                    self.navigationController?.pushViewController(cityVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "No city found with that name"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error locationManager: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            geocoder.reverseGeocodeLocation(location) {
                (placemarks,error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    self.detectedCityName = "\(placemark.locality!)"
                    self.getAPIData(cityName: placemark.locality!) {
                        response in
                        if let response = response {
                            let city = response
                            self.cities.append(city)
                            DispatchQueue.main.async {
                                self.conditionIcon.image = UIImage(systemName: city.weather.getConditionIconName())
                                self.conditionLabel.text = city.name
                                self.tempLabel.text = "\(city.weather.temperature)"
                            }
                        }
                    }
                }
            }
        }
    }
    
    weak var delegate: HomeViewControllerDelegate?
    var isDarkMode = false
    let locationManager = CLLocationManager()
    let authLocationStatus = CLLocationManager.authorizationStatus()
    let geocoder = CLGeocoder()
    let gradientLayer = CAGradientLayer()
    var detectedCityName = ""
    var cities = [City]() {
        didSet {
            if oldValue.count != cities.count {
                DispatchQueue.main.async {
                    self.updateUI()
                }
                
            }
        }
    }
    
    let welcomeLabel = UILabel()
    let errorLabel = UILabel()
    let weatherStackView = UIStackView()
    let conditionIcon = UIImageView()
    let conditionLabel = UILabel()
    let tempLabel = UILabel()
    let locatiesLabel = UILabel()
    let searchBar = UISearchController(searchResultsController: nil)
    let searchBarContainer = UIView()
    let stackView = UIStackView()
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestLocation()

        // Do any additional setup after loading the view.
        setBackground()
        view.layer.addSublayer(gradientLayer)
        title = "Home"
        
        //MenuButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.circle"), style: .done, target: self, action: #selector(didTapMenuButton))
        
        //Themebutton
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "lightbulb.circle.fill"), style: .done, target: self, action: #selector(didTapThemeButton))
        
        //welcomeLabel that adapts to the time of day
        setupWelcomeLabel()
        
        // Error label for searchBar
        setupErrorLabel()
        
        //searchBar voor cities
        setupSearchBar()
        
        //detectedCity weather
        setupLocalWeatherLabels()
        
        //Jouw locaties-label
        setupJouwLocatiesLabel()
        
        // setupTestButtonLabel()
        
        //CollectionView voor locaties
        setupStackView()
        
        updateUI()
    }
    
    func updateCities(_ cities: [City]) {
        self.cities = cities
        self.updateUI()
    }
    
    func updateUI() {
        self.errorLabel.isHidden = true
        self.updateStackView()
    }
    
    func updateStackView() {
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for city in cities {
            self.addCityStackView(city: city)
        }
    }
    
    func setBackground() {
        
        let lightColors = [self.color(fromHexString: "#E4EfE9")!.cgColor,self.color(fromHexString: "#93A5CF")!.cgColor]
        let darkColors = [self.color(fromHexString: "#09203F")!.cgColor,self.color(fromHexString: "#537895")!.cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.frame = view.bounds
        if isDarkMode {
            gradientLayer.colors = darkColors
            welcomeLabel.textColor = .white
            locatiesLabel.textColor = .white
        } else {
            gradientLayer.colors = lightColors
            welcomeLabel.textColor = .black
            locatiesLabel.textColor = .black
        }
        
    }
    
    func setupErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.text = ""
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8).isActive = true
        errorLabel.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor).isActive = true
        
        errorLabel.isHidden = true
    }
    
    func setupStackView() {
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: locatiesLabel.bottomAnchor, constant: 8).isActive = true
        for city in cities {
            addCityStackView(city: city)
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: locatiesLabel.bottomAnchor, constant: 8).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addCityStackView(city: City) {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(containerView)
        let button = UIButton(type: .system)
        button.setTitle(city.name, for: .normal)
        button.addTarget(self,action: #selector(didTapCityButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
        let trashButton = UIButton(type: .system)
        trashButton.setTitle("Trash", for: .normal)
        trashButton.addTarget(self, action: #selector(didTapTrashButton(_:)), for: .touchUpInside)
        trashButton.setImage(UIImage(systemName: "trash"),for: .normal)
        trashButton.tintColor = .systemRed
        trashButton.tag = cities.firstIndex(of: city)!
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trashButton)
        button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        trashButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        trashButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func setupLocalWeatherLabels() {
        weatherStackView.axis = .vertical
        weatherStackView.distribution = .fillEqually
        view.addSubview(weatherStackView)
        
        weatherStackView.addArrangedSubview(conditionIcon)
        weatherStackView.addArrangedSubview(conditionLabel)
        weatherStackView.addArrangedSubview(tempLabel)
        
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        conditionIcon.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weatherStackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8).isActive = true

    }
    
    func setupJouwLocatiesLabel() {
        view.addSubview(locatiesLabel)
        locatiesLabel.text = "Jouw locaties"
        locatiesLabel.translatesAutoresizingMaskIntoConstraints = false
        locatiesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        locatiesLabel.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 40).isActive = true
        
        let lineView = UIView()
        view.addSubview(lineView)
        
        lineView.backgroundColor = .gray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        lineView.topAnchor.constraint(equalTo: locatiesLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    func setupSearchBar() {
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Geef een stad in"
        searchBar.searchBar.delegate = self
        
        searchBarContainer.addSubview(searchBar.searchBar)
        view.addSubview(searchBarContainer)
        
        searchBar.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBar.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor).isActive = true
        searchBar.searchBar.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor).isActive = true
        searchBar.searchBar.topAnchor.constraint(equalTo: searchBarContainer.topAnchor).isActive = true
        searchBar.searchBar.bottomAnchor.constraint(equalTo: searchBarContainer.bottomAnchor).isActive = true
        
        searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBarContainer.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor,constant: 8).isActive = true
        searchBarContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        navigationItem.searchController = searchBar
        definesPresentationContext = true
        
    }
    
    func setupWelcomeLabel() {
        welcomeLabel.textAlignment = .center
        view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 5 && hour < 12 {
            welcomeLabel.text = "Goedenmorgen"
        } else if hour >= 12 && hour < 18 {
            welcomeLabel.text = "Goedenmiddag"
        } else {
            welcomeLabel.text = "Goedenavond"
        }
        
    }
    
    
    // line.horizontal.3.circle
    // "".fill
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
        self.updateUI()
    }
    
    @objc func didTapThemeButton() {
        
        if !isDarkMode {
            isDarkMode = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "lightbulb.circle"), style: .done, target: self, action: #selector(didTapThemeButton))
        } else {
            isDarkMode = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "lightbulb.circle.fill"), style: .done, target: self, action: #selector(didTapThemeButton))
        }
        
        DispatchQueue.main.async {
            self.setBackground()
        }
    }
    
    @objc func didTapCityButton(_ sender: UIButton) {
        let cityVC = CityViewController(city: cities[sender.tag], cities: self.cities)
        cityVC.delegate = self
        navigationController?.pushViewController(cityVC, animated: true)
    }
    
    @objc func didTapTrashButton(_ sender: UIButton) {
        self.cities.remove(at: sender.tag)
        stackView.removeArrangedSubview(sender.superview!)
        sender.superview?.removeFromSuperview()
    }
    
    func color(fromHexString hexString: String) -> UIColor? {
        let hex = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        
        guard hex.count == 6,
              let hexValue = Int(hex, radix: 16) else {
            return nil
        }
        
        return UIColor(
            red: CGFloat((hexValue >> 16) & 0xFF) / 255.0,
            green: CGFloat((hexValue >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hexValue & 0xFF) / 255.0,
            alpha: 1.0
        )
    }

    func getAPIData(cityName: String, completion: @escaping (City?) -> ()) {
        let url = NSURL(string: "https://api.weatherapi.com/v1/current.xml?key=50733048078f462e8fa115246220304&q=\(cityName.replacingOccurrences(of: " ", with: ""))&aqi=no")
        
        let city = City(name: cityName)
        let task = URLSession.shared.dataTask(with: url! as URL) {
            (data,response,error) in
            if data != nil
            {
                let feed=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                var xml = SWXMLHash.parse(feed)
                if let errorElement = xml["error"].element {
                    completion(nil)
                    return
                }
                xml = xml["root"]
                let region = xml["location"]["region"].element!.text
                let country = xml["location"]["country"].element!.text
                let localtime = xml["location"]["localtime"].element!.text
                let temp_c = xml["current"]["temp_c"].element!.text
                let condition = xml["current"]["condition"]["text"].element!.text
                let wind_kph = xml["current"]["wind_kph"].element!.text
                let wind_dir = xml["current"]["wind_dir"].element!.text
                let humidity = xml["current"]["humidity"].element!.text
                let cloud = xml["current"]["cloud"].element!.text
                
                city.setRegion(region: region)
                city.setCountry(country: country)
                let weather = Weather(localtime: localtime,temperature: (temp_c as NSString).floatValue, condition: condition, windKpH: (wind_kph as NSString).floatValue, windDirection: wind_dir, humidityPerc: (humidity as NSString).floatValue, cloudPerc: (cloud as NSString).floatValue)
                
                city.setWeather(weather: weather)
                completion(city)
            } else {
                print("Data is nil")
                completion(nil)
                return
            }
        }
        task.resume()
        
    }
    
        
        
}
