//
//  AppDelegate.swift
//  feds
//
//  Created by Alfred Thekkan on 9/1/16.
//  Copyright © 2016 Alfred. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleMaps
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey(GlobalConstants.GOOGLE_MAPS_API_KEY)
        registerForPushNotifications(application: application)
        Router.shared.setInitialViewController()
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open:url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }
    class DeviceToken {
        var tokenString: String?
    }
}
// Notifications
extension AppDelegate {
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = DeviceToken(deviceToken).tokenString else { return }
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
        
    }
}

extension AppDelegate.DeviceToken {
    convenience init(_ data: Data) {
        self.init()
        tokenString = data.map { String(format: "%02.2hhx", $0) }.joined()
    }
}
