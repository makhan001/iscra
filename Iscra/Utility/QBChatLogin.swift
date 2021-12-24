//
//  QBChatLogin.swift
//  Iscra
//
//  Created by m@k on 22/12/21.
//
import Quickblox
import Foundation

class QBChatLogin {
    static let shared = QBChatLogin()
    
    func setChatLoginSetup(email:String, password:String) {
        var userPassword = password
        if userPassword == "" {
            userPassword = "12345678"
        }
        QBRequest.logIn(withUserEmail: email, password: password) { (response, user) in
            let current = Profile()
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
                let userDefaults = UserDefaults.standard
                userDefaults.set(data, forKey: UserProfileConstant.curentProfile)
            } catch {
                debugPrint("[Profile] Couldn't write file to UserDefaults")
            }
            print(current.fullName)
            print("LoginChatSuccess",user)
            self.connectToChat(user: user, userPassword:userPassword)
            
        } errorBlock: { (response) in
            print("LoginChatNotSuccess",response)
        }
    }
    
    private func connectToChat(user: QBUUser, userPassword:String) {
        if QBChat.instance.isConnected == true {
            //did Login action
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
                print("Connected")
            }
        } else {
            QBChat.instance.connect(withUserID: user.id,
                                    password: userPassword,
                                    completion: { [weak self] error in
                guard let _ = self else { return }
                if let error = error {
                    if error._code == QBResponseStatusCode.unAuthorized.rawValue {
                        Profile.clearProfile()
                    } else {
                        print("not Connected")
                    }
                } else {
                    //did Login action
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
                        print("mak")
                    }
                }
            })
        }
    }
    
//    func setChatLoginSetup() {
//        //Spinner.show("")
//        // let userEmail = UserDefaults.standard.value(forKey: Message.shared.K_UserEmail) as? String ?? ""
//        let userPassword = "12345678"
//        QBRequest.logIn(withUserEmail: UserStore.userEmail ?? "",
//                password: userPassword) { (response, user) in
//          let current = Profile()
//          do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
//            let userDefaults = UserDefaults.standard
//            userDefaults.set(data, forKey: UserProfileConstant.curentProfile)
//          } catch {
//            debugPrint("[Profile] Couldn't write file to UserDefaults")
//          }
//          print(current.fullName)
//          print("LoginChatSuccess",user)
//          self.connectToChat(user: user)
//        } errorBlock: { (response) in
//          print("LoginChatNotSuccess",response)
//        }
//      }
      //Mark:- Connect to chat
//      private func connectToChat(user: QBUUser) {
//        //infoText = LoginStatusConstant.intoChat
//        let userPassword = "12345678"//"jitu12345"
//        if QBChat.instance.isConnected == true {
//          //did Login action
//          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
//            // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            //AppDelegate.shared.rootViewController.goToDialogsScreen()
//           // self.goToDialogsScreen()
//            self.inputedUsername = nil
//            self.inputedLogin = nil
//          }
//        } else {
//          QBChat.instance.connect(withUserID: user.id,
//                      password: userPassword,
//                      completion: { [weak self] error in
//            guard let self = self else { return }
//            if let error = error {
//              if error._code == QBResponseStatusCode.unAuthorized.rawValue {
//                // Clean profile
//                Profile.clearProfile()
//                // self.defaultConfiguration()
//              } else {
//                self.showAlertView(LoginConstant.checkInternet, message: LoginConstant.checkInternetMessage)
//                self.handleError(error, domain: ErrorDomain.logIn)
//              }
//            } else {
//              //did Login action
//              DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
//                // AppDelegate.shared.rootViewController.goToDialogsScreen()
//                //self.goToDialogsScreen()
//                self.inputedUsername = nil
//                self.inputedLogin = nil
//              }
//            }
//          })
//        }
//      }
}
