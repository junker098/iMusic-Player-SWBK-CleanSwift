//
//  MainTabBarController.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 29.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        let searchViewController: SearchViewController = SearchViewController.loadFromStoryboard()
        
        viewControllers = [
            generateViewController(searchViewController, #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon"), "Search"),
            generateViewController(ViewController(), #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon"), "Library")
        ]
    }
    
    private func generateViewController(_ rootVievController: UIViewController, _ image: UIImage, _ title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVievController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootVievController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
}
