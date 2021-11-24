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

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootController = RootCoordinator()
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.initialConfiguration()
        return true
    }
    
    func initialConfiguration() {
        Thread.sleep(forTimeInterval: 0.0)
        SVProgressHUD.setForegroundColor(UIColor.primaryAccent)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.10))
        SVProgressHUD.setRingThickness(5.0)
        IQKeyboardManager.shared.enable = true
        self.setNavigationBar()
        self.setRootController()
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

