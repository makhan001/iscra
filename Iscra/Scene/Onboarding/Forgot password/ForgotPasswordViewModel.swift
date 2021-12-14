//
//  ForgotPasswordViewModel.swift
//  Iscra
//
//  Created by mac on 03/12/21.
//

import UIKit
import Foundation

final class ForgotPasswordViewModel {
    
    var email: String = ""
    weak var view: OnboardingViewRepresentable?
    let provider: OnboardingServiceProvidable
    var delegate: OnboardingServiceProvierDelegate?

    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
        delegate = self
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
        self.provider.forgotPassword(param: UserParams.ForgotPassword(email: self.email))
    }
}

extension ForgotPasswordViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                    let code =  resp.data?.forgotPassword
                    let msg = (resp.message! + " code is " + code!)
                    self.view?.onAction(.forgotPassword(msg))
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
