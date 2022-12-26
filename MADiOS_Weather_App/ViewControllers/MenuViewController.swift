//
//  MenuViewController.swift
//  MADiOS_Weather_App
//
//  Created by Manu Vleurick on 26/12/2022.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case settings = "Your Locations"
        case info = "Info"
        case share = "Share"
        
        var imageName: String {
            switch self {
            case .home:
                return "house"
            case .settings:
                return "cogg"
            case .info:
                return "note"
            case .share:
                return "share"
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = nil
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    let greyColor = UIColor(red: 33/225.0, green: 33/225.0, blue: 33/225.0, alpha: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        view.backgroundColor = greyColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0,y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue// Get string value from the enum
        cell.backgroundColor = greyColor
        cell.contentView.backgroundColor = greyColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)// unhighlight bij deselect
    }

}
