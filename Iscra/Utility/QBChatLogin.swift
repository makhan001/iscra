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
             })
    }
    
    //Mark:- Login user in chat
    func loginQBUser(fullName: String, login: String, password: String = AppConstant.defaultQBUserPassword){
          QBRequest.logIn(withUserLogin: UserStore.userEmail ?? "",
                        password: AppConstant.defaultQBUserPassword,
                        successBlock: { [weak self] response, user in
                            guard let self = self else {
                                return
                            }
                            user.password = AppConstant.defaultQBUserPassword
                            Profile.synchronize(user)
                            if user.fullName != fullName {
                                print(user.fullName)
                               // self.updateFullName(fullName: fullName, login: login)
                            } else {
                                self.connectToChat(user: user)
                                print("user===>\(user)")
                            }
                            print("LoginChatSuccess",response)
                            
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
//    private func updateFullName(fullName: String, login: String) {
//        let updateUserParameter = QBUpdateUserParameters()
//        updateUserParameter.fullName = fullName
//        QBRequest.updateCurrentUser(updateUserParameter, successBlock: { [weak self] response, user in
//            guard let self = self else {
//                return
//            }
//            //self.infoText = LoginConstant.fullNameDidChange
//            Profile.update(user)
//            self.connectToChat(user: user, userPassword: AppConstant.defaultQBUserPassword)
//
//            }, errorBlock: { [weak self] response in
//                //self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
//        })
//    }
}
