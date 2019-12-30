//
//  AppDelegate.swift
//  SwiftOCDemo
//
//  Created by 张延深 on 2019/12/30.
//  Copyright © 2019 张延深. All rights reserved.
//

import UIKit
import NBFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NBConfigure.configSDK(with: nil);
        return true
    }


}

