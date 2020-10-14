//
//  MainTabBarController.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 29.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    let searchViewController: SearchViewController = SearchViewController.loadFromStoryboard()
    private var minimazidTopAnchorConstraint: NSLayoutConstraint!
    private var maximaizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAncorConstraint: NSLayoutConstraint!
    
    let trackDetailView:TrackDetailView = TrackDetailView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        setupTrackDetailView()
        searchViewController.tabBarDelegate = self
        
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
    
    private func setupTrackDetailView() {
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        trackDetailView.trackDetailViewDelegate = self
        trackDetailView.delegate = searchViewController
        
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        
        maximaizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimazidTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -70)
        bottomAncorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAncorConstraint.isActive = true
        maximaizedTopAnchorConstraint.isActive = true
        
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
    
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        
        maximaizedTopAnchorConstraint.isActive = true
        minimazidTopAnchorConstraint.isActive = false
        maximaizedTopAnchorConstraint.constant = 0
        bottomAncorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()   //обновление экрана каждую миллисек.
                        self.tabBar.alpha = 0
                        self.trackDetailView.miniTrackView.alpha = 0
                        self.trackDetailView.maximizedStackView.alpha = 1
        },
                       completion: nil)
        guard let viewMidels = viewModel else { return }
        self.trackDetailView.set(viewModel: viewMidels)
        
    }
    
    func minimizeTrackDetailController() {
        
        maximaizedTopAnchorConstraint.isActive = false
        bottomAncorConstraint.constant = view.frame.height
        minimazidTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()   //обновление экрана каждую миллисек.
                        self.tabBar.alpha = 1
                        self.trackDetailView.miniTrackView.alpha = 1
                        self.trackDetailView.maximizedStackView.alpha = 0 
        },
                       completion: nil)
    }
    
}
