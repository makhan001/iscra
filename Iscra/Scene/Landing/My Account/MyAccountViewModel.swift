//
//  MyAccountViewModel.swift
//  Iscra
//
//  Created by mac on 24/11/21.
//

import UIKit
import Foundation
import SVProgressHUD
import Quickblox

final class MyAccountViewModel {
    
    var email: String = ""
    var password: String = ""
    var username: String = ""
    var selectedImage: UIImage = UIImage()
    var webPage: WebPage = .termsAndConditions
    let provider: OnboardingServiceProvidable
    weak var view: OnboardingViewRepresentable?
    var delegate: OnboardingServiceProvierDelegate?
    private let chatManager = ChatManager.instance

    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
        delegate = self
    }
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType) {
        switch action {
        case .inputComplete: validateUserInput()
        default: break
        }
    }
    func logout() {
        self.provider.logout(param: UserParams.logout())
    }
    private func validateUserInput() {
        let parameters =  UserParams.UpdateProfile(username: UserStore.userName)
        WebService().requestMultiPart(urlString: APIConstants.updateProfile,
                                      httpMethod: .put,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": selectedImage]],
                                      fileArray: [],
                                      file: ["profile_image": selectedImage]){ [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .updateProfile, with: resp, with: nil)
                return
            } else {
                if let response = resp as? SuccessResponseModel  {
                    if response.status == true {
                        UserStore.save(token: response.data?.user?.authenticationToken)
                        UserStore.save(userName: response.data?.user?.username)
                        print("updateProfileApi Success---> \(response)")
                        UserStore.save(userID: response.data?.user?.id)
                        UserStore.save(userImage: response.data?.user?.profileImage)
                        self?.view?.onAction(.updateProfile)
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}
//MARK: OnboardingServiceProvierDelegate
extension MyAccountViewModel: OnboardingServiceProvierDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
               self.view?.onAction(.errorMessage(ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.status == true {
                    UserDefaults.standard.removeObject(forKey: "name")
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "user_id")
                    UserDefaults.standard.removeObject(forKey: "is_verify_key")
                    UserDefaults.standard.removeObject(forKey: "profile_image")
                    self.quickbloxLogout()
                    self.view?.onAction(.logout)
                    self.view?.onAction(.updateProfile)
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}

//MArk:- quickblox logout
extension MyAccountViewModel {
    
    private func quickbloxLogout(){
        guard Reachability.instance.networkConnectionStatus() != .notConnection else {
                  // showAlertView(LoginConstant.checkInternet, message: LoginConstant.checkInternetMessage)
                   return
               }
               
//               SVProgressHUD.show(withStatus: "SA_STR_LOGOUTING".localized)
//               SVProgressHUD.setDefaultMaskType(.clear)
               
               guard let identifierForVendor = UIDevice.current.identifierForVendor else {
                   return
               }
               let uuidString = identifierForVendor.uuidString
               #if targetEnvironment(simulator)
               disconnectUser()
               #else
               QBRequest.subscriptions(successBlock: { (response, subscriptions) in
                   if let subscriptions = subscriptions {
                       for subscription in subscriptions {
                           if let subscriptionsUIUD = subscriptions.first?.deviceUDID,
                              subscriptionsUIUD == uuidString,
                              subscription.notificationChannel == .APNS {
                            // self.unregisterSubscription(forUniqueDeviceIdentifier: uuidString) // madhuri
                               return
                           }
                       }
                   }
                   self.disconnectUser()
                   
               }) { (response) in
                   if response.status.rawValue == 404 {
                       self.disconnectUser()
                   }
               }
               #endif
           }
    func disconnectUser() {
        QBChat.instance.disconnect(completionBlock: { error in
            if let error = error {
              // SVProgressHUD.showError(withStatus: error.localizedDescription)
                return
            }
            self.LogOut()
        })
    }
     func LogOut() {
        QBRequest.logOut(successBlock: { [] response in
            //ClearProfile
            Profile.clearProfile()
            self.chatManager.storage.clear()
            CacheManager.shared.clearCache()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
               // AppDelegate.shared.rootViewController.showLoginScreen()
                
            }
           // SVProgressHUD.showSuccess(withStatus: "SA_STR_COMPLETED".localized)
        }) { response in
            debugPrint("[DialogsViewController] logOut error: \(response)")
        }
    }
}

