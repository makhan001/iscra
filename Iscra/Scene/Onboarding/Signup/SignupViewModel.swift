//
//  SignupViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import Foundation

final class SignupViewModel {
    
    var email: String = ""
    var username: String = OnboadingUtils.shared.username // singeleton class
    var password: String = ""
    var selectedImage: UIImage! = OnboadingUtils.shared.userImage // singleton class
    
    weak var view: OnboardingViewRepresentable?
    let provider: OnboardingServiceProvidable
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType) {
        switch action {
        case .inputComplete: validateUserInput()
        default: break
        }
    }
    
    private func validateUserInput() {
        //        if username == "" {
        //            view?.onAction(.requireFields("Username is required"))
        //            return
        //        }
        
        //        if email == "" {
        //            view?.onAction(.requireFields("Email is required"))
        //            return
        //        }
        if Validation().textValidation(text: email, validationType: .email).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: email, validationType: .email).1))
            return
        }
        
        if Validation().textValidation(text: password, validationType: .password).0 {
            view?.onAction(.requireFields("Password is required"))
            return
        }
        self.provider.register(param: UserParams.Signup(email: email, username: username, password: password, fcm_token: UserStore.fcmtoken, device_id: nil, device_type: "ios"))
    }
}

extension SignupViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                //                guard let message = error?.responseData?.message else {
                //                    self.view?.onAction(.errorMessage(ERROR_MESSAGE))
                //                    return
                //                }
                self.view?.onAction(.errorMessage(ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.status == true {
                    //                   self.register = resp.data?.register
                    self.view?.onAction(.register)
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
