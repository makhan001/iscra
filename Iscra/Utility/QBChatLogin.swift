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
    
    //Mark:- Signp user in chat
    func registerQBUser() {
        let user = QBUUser()
        user.email = UserStore.userEmail
        user.login = UserStore.userEmail
        user.fullName = UserStore.userName
        user.customData = UserStore.userImage
        user.password =  AppConstant.defaultQBUserPassword
        
        QBRequest.signUp(user, successBlock: { [weak self] response, user in
            guard let self = self else {
                return
            }
            self.loginQBUser(fullName: UserStore.userName ?? "", login: UserStore.userEmail ?? "", email: UserStore.userEmail ?? "", customData: UserStore.userImage ?? "")
            print("UserSignUpInQuickBlox", user)
            }, errorBlock: { [weak self] response in
                
                if response.status == QBResponseStatusCode.validationFailed {
                    // The user with existent login was created earlier
                    self?.loginQBUser(fullName: UserStore.userName ?? "", login: UserStore.userEmail ?? "", email: UserStore.userEmail ?? "", customData: UserStore.userImage ?? "")
                    return
                }
                print("UserNOTSignUpInQuickBlox", response)
             })
    }
    
    //Mark:- Login user in chat
    func loginQBUser(fullName: String, login: String, password: String = AppConstant.defaultQBUserPassword, email: String, customData: String){
          QBRequest.logIn(withUserLogin: UserStore.userEmail ?? "",
                        password: AppConstant.defaultQBUserPassword,
                        successBlock: { [weak self] response, user in
                            guard let self = self else {
                                return
                            }
                            let current = Profile()
                                do {
                                    let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(data, forKey: UserProfileConstant.curentProfile)
                                    } catch {
                                        debugPrint("[Profile] Couldn't write file to UserDefaults")
                                    }
                                    print(current.fullName)
                                    print(current.customData)
                                    print(current.login)
                                    print("LoginChatSuccess",user)
                                    self.connectToChat(user: user)
                            
            }, errorBlock: { [weak self] response in
              if response.status == QBResponseStatusCode.unAuthorized {
                    Profile.clearProfile()
                    print("LoginChatNotSuccess",response)
                }
               
        })
        
    }
    //Mark:- Connect to chat
    private func connectToChat(user: QBUUser) {
       if QBChat.instance.isConnected == true {
           DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
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
                                            }
                                        } else {
                                        }
                                    })
            }
    }
}
