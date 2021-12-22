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
    
    //Mark:- Login Chat
    func setChatLoginSetup() {
        let userPassword = "12345678"
        
        QBRequest.logIn(withUserEmail: UserStore.userEmail ?? "",
                        password: userPassword) { (response, user) in
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
            self.connectToChat(user: user)
            
        } errorBlock: { (response) in
            print("LoginChatNotSuccess",response)
        }
    }
    
    //Mark:- Connect to chat
    private func connectToChat(user: QBUUser) {
        //infoText = LoginStatusConstant.intoChat
        let userPassword = "12345678"//"jitu12345"
        
        if QBChat.instance.isConnected == true {
            //did Login action
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
                
            }
        } else {
            QBChat.instance.connect(withUserID: user.id,
                                    password: userPassword,
                                    completion: { [weak self] error in
                guard let _ = self else { return }
                if let error = error {
                    if error._code == QBResponseStatusCode.unAuthorized.rawValue {
                        // Clean profile
                        Profile.clearProfile()
                        print(error.localizedDescription)
                    } else {
                        UserStore.save(chatLogin: true)
                        print("Successfully login on QB")
                    }
                } else {
                    //did Login action
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .nanoseconds(Int(0.01))) {
                        print("QB others actions")
                    }
                }
            })
        }
    }
    
    
}
