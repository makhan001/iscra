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
    var username: String = OnboadingUtils.shared.username // singeleton class
    var selectedImage: UIImage! = OnboadingUtils.shared.userImage // singleton class
    var delegate: OnboardingServiceProvierDelegate?

    weak var view: OnboardingViewRepresentable?
    let provider: OnboardingServiceProvidable
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
        delegate = self
    }
    
   
    
     func logout() {
        self.provider.logout(param: UserParams.logout())
    }
}

extension MyAccountViewModel: OnboardingServiceProvierDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
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
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}

