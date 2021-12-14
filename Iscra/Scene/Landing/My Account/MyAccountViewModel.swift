//
//  MyAccountViewModel.swift
//  Iscra
//
//  Created by mac on 24/11/21.
//

import UIKit
import Foundation

final class MyAccountViewModel {
    
    var email: String = ""
    var password: String = ""
    var username: String = ""
    var selectedImage: UIImage = UIImage()
    let provider: OnboardingServiceProvidable
    weak var view: OnboardingViewRepresentable?
    var delegate: OnboardingServiceProvierDelegate?
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
        WebService().requestMultiPart(urlString: "/users/update",
                                      httpMethod: .put,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": selectedImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["profile_image": selectedImage ?? UIImage()]){ [weak self](resp, err) in
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
//Mark:- OnboardingServiceProvierDelegate
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
                    self.view?.onAction(.logout)
                    self.view?.onAction(.updateProfile)
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}


