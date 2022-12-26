//
//  ViewController.swift
//  MADiOS_Weather_App
//
//  Created by Manu Vleurick on 26/12/2022.
//

import UIKit

class ViewController: UIViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Hellow world"
        view.backgroundColor = .systemBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addChildVCs()
    }
    
    private func addChildVCs() {
        // Menu
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        // Home
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        
    }


}

extension ViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        // Animate menu
        switch menuState{
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                    
                
                self.homeVC.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
                
            } completion : { done in
                if done {
                    
                }
            }
        case .opened:
            
            break
            
        }
    }
}
