//
//  AppDelegate.swift
//  SocialLoginSample
//
//  Created by joon-ho kil on 2020/02/05.
//  Copyright © 2020 joon-ho kil. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isInAppOauthEnable = true // --- 1
        instance?.isNaverAppOauthEnable = true // --- 2
        instance?.isOnlyPortraitSupportedInIphone() // --- 3
        // --- 4
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
        return true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
      return true
    }
}

