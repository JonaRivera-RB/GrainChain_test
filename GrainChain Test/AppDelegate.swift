//
//  AppDelegate.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 29/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //GMSPlacesClient.provideAPIKey("Your key")
        GMSServices.provideAPIKey("AIzaSyDofI2JoYtYIEdueCv_CTGSW_iiKaDM3L4")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        window?.rootViewController = MainTabController()
        
        return true
    }
}

