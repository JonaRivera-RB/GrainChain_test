//
//  SceneDelegate.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 29/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = MainTabController()
        window?.makeKeyAndVisible()
    }

}

