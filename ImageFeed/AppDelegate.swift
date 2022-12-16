//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Илья Валито on 21.11.2022.
//

import UIKit

// Warning: This method should not be called on the main thread as it may lead to UI unresponsiveness.
// Based on apple bug reports - there is no solution for this bug yet (https://developer.apple.com/forums/thread/712074)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}
