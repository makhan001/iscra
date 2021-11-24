//
//  AppDelegate.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import CoreData
import SVProgressHUD
import IQKeyboardManagerSwift
import UserNotifications
import Quickblox

struct CredentialsConstant {
    static let applicationID:UInt = 94500
    static let authKey = "UA5G7ZR4-z-hRM9"
    static let authSecret = "cT-CPm-3TBU8-42"
    static let accountKey = "qamiD7ximJfGsNrs-FyX"
}
//struct CredentialsConstant {
//    static let applicationID:UInt = 93900
//    static let authKey = "hyE37qMZc44eW9f"
//    static let authSecret = "3qj7mPMx5jfqyfr"
//    static let accountKey = "vs49Hh-LaaKEe7gyyEFA"
//}

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUps()
        application.applicationIconBadgeNumber = 0
       //Quick blox initial setup
        self.setQuickBloxSetup()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return true
    }
    func setQuickBloxSetup() {
        QBSettings.applicationID = CredentialsConstant.applicationID
        QBSettings.authKey = CredentialsConstant.authKey
        QBSettings.authSecret = CredentialsConstant.authSecret
        QBSettings.accountKey = CredentialsConstant.accountKey
        
        // enabling carbons for chat with same id in multiple device
        QBSettings.carbonsEnabled = true
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        QBSettings.logLevel = .debug
        QBSettings.autoReconnectEnabled = true

    }
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Logging out from chat.
//        ChatManager.instance.disconnect()
//    }
//    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Logging in to chat.
//        ChatManager.instance.connect()
//    }
    
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
    //MARK: - UNUserNotification
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        guard let identifierForVendor = UIDevice.current.identifierForVendor else {
            return
        }
        
        let deviceIdentifier = identifierForVendor.uuidString
        let subscription = QBMSubscription()
        subscription.notificationChannel = .APNS
        subscription.deviceUDID = deviceIdentifier
        subscription.deviceToken = deviceToken
        QBRequest.createSubscription(subscription, successBlock: { response, objects in
        }, errorBlock: { response in
            debugPrint("[AppDelegate] createSubscription error: \(String(describing: response.error))")
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("[AppDelegate] Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Iscra")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

@available(iOS 13.0, *)
extension AppDelegate{
    func setUps(){
        SVProgressHUD.setForegroundColor(UIColor.primaryAccent)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.10))
        SVProgressHUD.setRingThickness(5.0)
        IQKeyboardManager.shared.enable = true
        navigationSetup()
        Thread.sleep(forTimeInterval: 3.0)
    }
}
@available(iOS 13.0, *)
extension AppDelegate : CLLocationManagerDelegate {
    func navigationSetup(){
        //var naviObj : UINavigationController?
        let navigation = UINavigationBar.appearance()
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigation.shadowImage = UIImage()
        navigation.tintColor = UIColor.init(named: "GrayAccent")
        navigation.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Black", size: 24) ?? UIFont(), NSAttributedString.Key.foregroundColor :UIColor(named: "GrayAccent") ?? UIColor.lightGray]
        // naviObj?.interactivePopGestureRecognizer?.isEnabled = false
        navigation.backIndicatorImage = UIImage(named: "Back")
        navigation.backIndicatorTransitionMaskImage = UIImage(named: "Back")
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), for: .default)
        navigation.setTitleVerticalPositionAdjustment(0, for: .default)
        navigation.isTranslucent = false
    }
}
//MARK: - UNUserNotificationCenterDelegate
@available(iOS 13.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if UIApplication.shared.applicationState == .active {
            completionHandler()
            return
        }
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        guard let dialogID = userInfo["SA_STR_PUSH_NOTIFICATION_DIALOG_ID".localized] as? String,
              dialogID.isEmpty == false else {
            completionHandler()
            return
        }
        DispatchQueue.main.async {
            if ChatManager.instance.storage.dialog(withID: dialogID) != nil {
               // self.rootViewController.dialogID = dialogID
            } else {
                ChatManager.instance.loadDialog(withID: dialogID, completion: { (loadedDialog: QBChatDialog?) -> Void in
                    guard loadedDialog != nil else {
                        return
                    }
//self.rootViewController.dialogID = dialogID
                })
            }
        }
        completionHandler()
    }
}
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

