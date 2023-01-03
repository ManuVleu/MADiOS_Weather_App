import UIKit
import Foundation
import SWXMLHash
import CoreLocation

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, CLLocationManagerDelegate   {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as! CityCell
        let city = cities[indexPath.item]
        cell.configure(with: city)
        return cell
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
                    self.detectedCity = "\(placemark.locality!)"
                    self.getAPIData(cityName: self.detectedCity) {
                        response in
                        if let response = response {
                            let city = response
                            self.cities.append(city)
                        }
                    }
                }
            }
        }
    }
    
    weak var delegate: HomeViewControllerDelegate?
    let locationManager = CLLocationManager()
    let authLocationStatus = CLLocationManager.authorizationStatus()
    let geocoder = CLGeocoder()
    var detectedCity = ""
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
    let locatiesLabel = UILabel()
    let searchBar = UISearchBar()
    let testButton = UIButton(type: .system)
    let testLabel = UILabel()
    let layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.requestLocation()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Home"
        
        //MenuButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.circle"), style: .done, target: self, action: #selector(didTapMenuButton))
        
        //welcomeLabel that adapts to the time of day
        setupWelcomeLabel()
        
        //searchBar voor cities
        setupSearchBar()
        
        //Jouw locaties-label
        setupJouwLocatiesLabel()
        
        setupTestButtonLabel()
        //CollectionView voor locaties
        setupLocatiesCView()
        
        
    }
    
    func updateUI() {
        self.testLabel.text = self.detectedCity
    }
    

    func setupTestButtonLabel() {
        testButton.setTitle("Click me!", for: .normal)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testButton)
        testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        testButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        testButton.topAnchor.constraint(equalTo: locatiesLabel.bottomAnchor, constant: 8).isActive = true
        testButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        view.addSubview(testLabel)
        testLabel.text = detectedCity
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        testLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        testLabel.topAnchor.constraint(equalTo: testButton.bottomAnchor, constant: 20).isActive = true
    }
    
    func setupLocatiesCView() {
        // Initialize the collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)

        // Set up the layout
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        // Set up the collection view constraints
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: locatiesLabel.bottomAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        // Set up the collection view data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self

        // Register a cell class for the collection view
        collectionView.register(CityCell.self, forCellWithReuseIdentifier: "cityCell")
    }
    
    func setupJouwLocatiesLabel() {
        view.addSubview(locatiesLabel)
        locatiesLabel.text = "Jouw locaties"
        locatiesLabel.translatesAutoresizingMaskIntoConstraints = false
        locatiesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        locatiesLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40).isActive = true
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.placeholder = "Geef een stad in"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8).isActive = true
        
        searchBar.layer.cornerRadius = 10
        
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
    }

    @objc func didTapButton() {
        self.testLabel.text = self.detectedCity
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
