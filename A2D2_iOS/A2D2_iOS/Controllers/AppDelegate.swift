//
//  AppDelegate.swift
//  A2D2_iOS
//
//  Created by Justin Godsey on 11/13/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataSourceUtils.initFirebase()
        DataSourceUtils.initDateFormatters()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let currentView = application.keyWindow?.rootViewController
        if(!SystemUtils.isConnectedToNetwork()) {
            alertNoConnection(currentView!)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func alertNoConnection(_ view : UIViewController) {
        let alert = UIAlertController(title: "No Connection!", message: "Can't connect to the internet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        view.present(alert, animated: true)
    }
}

