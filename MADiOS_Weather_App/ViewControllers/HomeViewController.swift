import UIKit
import Foundation

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate   {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as! CityCell
        let city = cities[indexPath.item]
        cell.configure(with: city)
        return cell
    }
    
    
    
    weak var delegate: HomeViewControllerDelegate?
    var cities = [City]()
    
    let welcomeLabel = UILabel()
    let locatiesLabel = UILabel()
    let searchBar = UISearchBar()
    let testButton = UIButton(type: .system)
    let testLabel = UILabel()
    let layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

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

        let url = NSURL(string: "https://www.nytimes.com/svc/collections/v1/publish/https://www.nytimes.com/section/world/rss.xml")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {
            (data,response,error) in
            if data != nil
            {
                let feed=NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let xml = SWXMLHash.parse(feed)
                print(xml)
            
            } else {
                print("Data is nil")
            }
        }
        task.resume()
        
       
        
        
        //CollectionView voor locaties
        //setupLocatiesCView()
        
        
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
        testLabel.text = "tstLabel"
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

    @objc func didTapButton() async {
        let city = City(name: "Ghent")
        //let res = await city.setWeatherData()
        //getDataFromAPI { (weather) in

            //print(weather)
        //}
    }
    
        
        
}
