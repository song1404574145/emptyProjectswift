//
//  AppDelegate.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = XDBaseTabBar()
        window?.makeKeyAndVisible()
        return true
    }
}

