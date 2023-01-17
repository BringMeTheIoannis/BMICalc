//
//  RootViewController.swift
//  BMICalc
//
//  Created by Ivan Kuzmenkov on 3.11.22.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBMIViewController()
//        setNavItem()
    }
    
    func setNavItem() {
        let imageMenu = UIImage(systemName: "line.3.horizontal")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        let menuItem = UIBarButtonItem(image: imageMenu, style: .plain, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = menuItem
    }
    
    func setBMIViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let bmiVC = storyboard.instantiateViewController(withIdentifier: String(describing: BMIViewController.self)) as? BMIViewController
        guard let bmiVC = bmiVC else { return }
        view.addSubview(bmiVC.view)
        addChild(bmiVC)
    }
}
