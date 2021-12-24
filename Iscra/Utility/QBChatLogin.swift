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
}
