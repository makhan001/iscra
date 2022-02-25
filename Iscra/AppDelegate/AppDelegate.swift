//
//  AppDelegate.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import CoreData
import Firebase
import Quickblox
import GoogleSignIn
import FacebookCore
import SVProgressHUD
import IQKeyboardManagerSwift

struct CredentialsConstant {
    static let applicationID:UInt = 94837
    static let authKey = "u23O6e2xksURPzD"
    static let authSecret = "yNWuKMAOBVzxxp8"
    static let accountKey = "HzaDQCQWWVkatEE9qjV-"
}

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootController = RootCoordinator()
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initialConfiguration()
        self.requestForNotification()

//        Settings.isAdvertiserTrackingEnabled = false
//        Settings.shared.isAutoLogAppEventsEnabled = true
//        AppEvents.shared.activateApp()
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        Settings.isAutoLogAppEventsEnabled = true
        Settings.isCodelessDebugLogEnabled = true
        Settings.setAdvertiserTrackingEnabled(true)
    
     //   Settings.isAutoInitEnabled = true

        return true
    }
    
    private func requestForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound]) { (granted, error) in
            if granted {
                UserStore.save(pushDisableCount: 0)
            } else if let userPushCount = UserStore.pushDisableCount {
                UserStore.save(pushDisableCount: userPushCount + 1)
            }
        }
    }
    
    
    private func initialConfiguration() {
        Thread.sleep(forTimeInterval: 0.0)
        UNUserNotificationCenter.current().delegate = self
        self.setHUD()
        self.setupQuickBlox()
        self.setNavigationBar()
        FirebaseApp.configure()
        self.setRootController()
        self.registerForRemoteNotifications()
        IQKeyboardManager.shared.enable = true
        _ = GIDConfiguration.init(clientID: "737448075691-v86u462dj0cepp37pukugf53cg7fbom2.apps.googleusercontent.com")
    }
    
    private func setHUD() {
        SVProgressHUD.setForegroundColor(UIColor.primaryAccent)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.10))
        SVProgressHUD.setRingThickness(5.0)
    }
    
    private func setupQuickBlox() {
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
    
    func setNavigationBar() {
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
    
    func setRootController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            self.rootController.start(window: window)
        }
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
    
    //    func applicationDidBecomeActive(_ application: UIApplication) {
    //        print("applicationDidBecomeActive")
    //        AppDelegate.shared.requestNotificationPermission()
    //    }
    
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

//MARK: - UNUserNotificationCenterDelegate
@available(iOS 13.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
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
    
    private func registerForRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { granted, error in
            if let error = error {
                debugPrint("registerForRemoteNotifications error: \(error.localizedDescription)")
                return
            }
            center.getNotificationSettings(completionHandler: { settings in
                if settings.authorizationStatus != .authorized {
                    return
                }
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            })
        })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Devcie token for apns ==== \(token)")
        //        Messaging.messaging().apnsToken = deviceToken
        UserStore.save(apnsToken: token)
        
        //        Messaging.messaging().token { token, error in
        //            if let error = error {
        //                print("Error fetching FCM registration token: \(error)")
        //            } else if let token = token {
        //                print("FCM registration token: \(token)")
        //                UserStore.save(fcmtoken: token)
        //            }
        //        }
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

//MARK: - trigger Local Notification and its Permission
extension AppDelegate {
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.triggerLocalNotification()
            } else if let pushDisableCount = UserStore.pushDisableCount,
                       (pushDisableCount <= 2 && pushDisableCount != 0) {
                self.alertForPermission()
            }
        }
    }
    
    private func triggerLocalNotification() {
        if UserStore.token != nil && UserStore.isVerify  == true {
            let content = UNMutableNotificationContent()
            content.title = "Iscra"
            content.body = "Hey! It’s time to build your new habit. Don’t dream about success, work for it!"
            
            var dateComponents = DateComponents()
             dateComponents.hour = 16
            dateComponents.minute = 0
            
            // Create the request
            let request = UNNotificationRequest(identifier: "Iscra",content: content, trigger:  UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true))
            
            // Schedule the request with the system.
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    private func opensSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
    }
    
    private func alertForPermission() {
        let alertController = UIAlertController(title: AppConstant.notificationPermission, message: AppConstant.notificationPermissionMessage, preferredStyle: .alert)
        let OpenSettingAction = UIAlertAction(title: "Open settings", style: .default) { (action: UIAlertAction!) in
            self.opensSettings()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            UserStore.save(pushDisableCount: UserStore.pushDisableCount! + 1)
        }
        OpenSettingAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(OpenSettingAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alertController, animated: true, completion:nil)
        }
    }
}
