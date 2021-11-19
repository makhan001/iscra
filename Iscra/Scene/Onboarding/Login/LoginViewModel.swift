//
//  SignupViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 18/11/21.
//

import UIKit
import Foundation

final class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    
    weak var view: OnboardingViewRepresentable?
    let provider: OnboardingServiceProvidable
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType) {
        switch action {
        case .inputComplete(screen): validateUserInput()
        default: break
        }
    }
    
    private func validateUserInput() {
        if Validation().textValidation(text: email, validationType: .email).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: email, validationType: .email).1))
            return
        }
        
        if Validation().textValidation(text: password, validationType: .password).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: password, validationType: .password).1))
            return
        }
        
        self.provider.login(param: UserParams.Login(email: email, password: password))
    }
}

extension LoginViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                self.view?.onAction(.errorMessage(ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                    UserStore.save(token: resp.data?.loginData?.token)
                    self.view?.onAction(.login)
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
