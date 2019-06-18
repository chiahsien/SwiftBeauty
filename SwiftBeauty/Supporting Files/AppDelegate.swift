//
//  AppDelegate.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/2.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: RootCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigation = CustomNavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = navigation
        coordinator = RootCoordinator(navigationController: navigation)
        coordinator.start()
        window!.makeKeyAndVisible()
        return true
    }
}
