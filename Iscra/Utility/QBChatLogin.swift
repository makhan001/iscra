//
//  QBChatLogin.swift
//  Iscra
//
//  Created by m@k on 22/12/21.
//
import Quickblox
import Foundation
import UIKit

class QBChatLogin {
    static let shared = QBChatLogin()
    
        var dialogID: String? {
            didSet {
                handlePush()
            }
        }
    func registerQBUser() {
       
//        let user = QBUUser()
//        user.email = UserStore.userEmail
//        user.login = UserStore.userEmail
//        user.fullName = UserStore.userName
//        user.password = AppConstant.defaultQBUserPassword
//        QBRequest.signUp(user, successBlock: { response, user in
//            print("UserSignUpInQuickBlox", user)
//        }, errorBlock: { (response) in
//            print("UserNOTSignUpInQuickBlox", response)
//        })
        let user = QBUUser()
        user.login = UserStore.userEmail
        user.fullName = UserStore.userName
        user.password =  AppConstant.defaultQBUserPassword
        
        QBRequest.signUp(user, successBlock: { [weak self] response, user in
            guard let self = self else {
                return
            }
            self.loginQBUser(fullName: UserStore.userName ?? "", login: UserStore.userEmail ?? "")
            print("UserSignUpInQuickBlox", user)
            }, errorBlock: { [weak self] response in
                
                if response.status == QBResponseStatusCode.validationFailed {
                    // The user with existent login was created earlier
                    self?.loginQBUser(fullName: UserStore.userName ?? "", login: UserStore.userEmail ?? "")
                    return
                }
                print("UserNOTSignUpInQuickBlox", response)
             //   self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
        })
    }
    
    //func loginQBUser(email:String) {
    func loginQBUser(fullName: String, login: String, password: String = AppConstant.defaultQBUserPassword){
//        QBRequest.logIn(withUserEmail: email, password: AppConstant.defaultQBUserPassword) { (response, user) in
//            let current = Profile()
//            do {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
//                let userDefaults = UserDefaults.standard
//                userDefaults.set(data, forKey: UserProfileConstant.curentProfile)
//            } catch {
//                debugPrint("[Profile] Couldn't write file to UserDefaults")
//            }
//            print(current.fullName)
//            self.connectToChat(user: user, userPassword:AppConstant.defaultQBUserPassword)
//
//        } errorBlock: { (response) in
//            print("LoginChatNotSuccess",response)
//        }
        
        QBRequest.logIn(withUserLogin: login,
                        password: password,
                        successBlock: { [weak self] response, user in
                            guard let self = self else {
                                return
                            }
                            
                            user.password = password
                            Profile.synchronize(user)
                            
                            if user.fullName != fullName {
                               // self.updateFullName(fullName: fullName, login: login)
                            } else {
                                self.connectToChat(user: user, userPassword: AppConstant.defaultQBUserPassword)
                            }
                            print("LoginChatSuccess",response)
                            
            }, errorBlock: { [weak self] response in
               // self?.handleError(response.error?.error, domain: ErrorDomain.logIn)
                if response.status == QBResponseStatusCode.unAuthorized {
                    // Clean profile
                    Profile.clearProfile()
                   // self?.defaultConfiguration()
                    print("LoginChatNotSuccess",response)
                }
                print("LoginChatNotSuccess",response)
        })
        
    }
    
    private func connectToChat(user: QBUUser, userPassword:String) {
//        if QBChat.instance.isConnected == true {
//            //did Login action
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
//                print("Connected")
//            }
//        } else {
//            QBChat.instance.connect(withUserID: user.id,
//                                    password: userPassword,
//                                    completion: { [weak self] error in
//                guard let _ = self else { return }
//                if let error = error {
//                    if error._code == QBResponseStatusCode.unAuthorized.rawValue {
//                        Profile.clearProfile()
//                    } else {
//                        print("not Connected")
//                    }
//                } else {
//                    //did Login action
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
//                        AppDelegate.shared.setRootController().self
//                        print("mak")
//                    }
//                }
//            })
//        }
        if QBChat.instance.isConnected == true {
            //did Login action
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                //AppDelegate.shared.rootController.goToDialogsScreen()
             
            }
        } else {
            QBChat.instance.connect(withUserID: user.id,
                                    password: AppConstant.defaultQBUserPassword,
                                    completion: { [weak self] error in
                                        guard let self = self else { return }
                                        if let error = error {
                                            if error._code == QBResponseStatusCode.unAuthorized.rawValue {
                                                // Clean profile
                                                Profile.clearProfile()
                                                //self.defaultConfiguration()
                                            } else {
                                               // self.showAlertView(LoginConstant.checkInternet, message: LoginConstant.checkInternetMessage)
                                                //self.handleError(error, domain: ErrorDomain.logIn)
                                            }
                                        } else {
                                            //did Login action
                                           // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
                                               // AppDelegate.shared.rootViewController.goToDialogsScreen()
                                           // self.goToDialogsScreen()
                                              //  self.inputedUsername = nil
                                        
                                               // self.inputedLogin = nil
                                           // }
                                        }
                                    })
            
        }
    }
//    func goToDialogsScreen() {
//        let storyboard = UIStoryboard(name: "Dialogs", bundle: nil)
//        if let dialogs = storyboard.instantiateViewController(withIdentifier: "DialogsViewController") as? DialogsViewController {
//            let dialogsScreen = DialogsNavigationController(rootViewController: dialogs)
//            dialogsScreen.navigationBar.barTintColor = #colorLiteral(red: 0.2216441333, green: 0.4713830948, blue: 0.9869660735, alpha: 1)
//            dialogsScreen.navigationBar.barStyle = .black
//
//            dialogsScreen.navigationBar.isTranslucent = true
//            dialogsScreen.navigationBar.tintColor = .white
//            dialogsScreen.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
//           // changeCurrentViewController(dialogsScreen)
//                 //  handlePush()
//            }
//    }
   
//        private func changeCurrentViewController(_ newCurrentViewController: UIViewController) {
//            addChild(newCurrentViewController)
//            newCurrentViewController.view.frame = view.bounds
//            view.addSubview(newCurrentViewController.view)
//            newCurrentViewController.didMove(toParent: self)
//            var current: UIViewController = newCurrentViewController
//            if current == newCurrentViewController {
//                return
//            }
//            current.willMove(toParent: nil)
//            current.view.removeFromSuperview()
//            current.removeFromParent()
//            current = newCurrentViewController
//        }
//
//        private func handlePush() {
//            let storyboardDia = UIStoryboard(name: "Dialogs", bundle: nil)
//            let dialogsVC = storyboardDia.instantiateViewController(withIdentifier: "DialogsViewController") as? DialogsViewController
//            let dialogsScreen = DialogsNavigationController(rootViewController: dialogsVC!)
//            if let dialogsNavigationController = dialogsVC as? DialogsNavigationController, let dialogID = dialogID {
//                if let dialog = ChatManager.instance.storage.dialog(withID: dialogID) {
//                    // Autojoin to the group chat
//                    if dialog.type != .private, dialog.isJoined() == false {
//                        dialog.join(completionBlock: { error in
//                            guard let error = error else {
//                                return
//                            }
//                            debugPrint("[RootParentVC] dialog.join error: \(error.localizedDescription)")
//                        })
//                    }
//                    dialogsNavigationController.popToRootViewController(animated: false)
//                    (dialogsNavigationController.topViewController as? DialogsViewController)?.openChatWithDialogID(dialogID)
//                    self.dialogID = nil
//                }
//            }
//        }
//        // MARK: - Handle errors
//        private func handleError(_ error: Error?, domain: ErrorDomain) {
//            guard let error = error else {
//                return
//            }
//            var infoText = error.localizedDescription
//            if error._code == NSURLErrorNotConnectedToInternet {
//                infoText = LoginConstant.checkInternet
//            }
//        }
    
}
