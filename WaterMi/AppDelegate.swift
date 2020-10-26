//
//  AppDelegate.swift
//  WaterMi
//
//  Created by Sascha on 21.10.20.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let plantDatabaseManager = PlantDatabaseManager()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Google Mobile Adds
        //GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["3173de5b2ceb14db7a5089a8fb761182"]
        
        // Reset the Notification badge Count when starting the app
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }

//MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.plantDatabaseManager.savePlants()
    }
}

