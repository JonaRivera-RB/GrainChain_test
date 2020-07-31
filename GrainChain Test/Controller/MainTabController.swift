//
//  MainTabController.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 29/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Helpers
    private func configureViewController() {
        let Map = MapVC()
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: Map)
        
        let UserRoutes = UserRoutesVC()
        let nav2 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: UserRoutes)
        
        viewControllers = [nav1, nav2]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.tabBarItem.image = image
        navigation.navigationBar.barTintColor = .white
        return navigation
    }
}


