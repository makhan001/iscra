//
//  ChangePasswordViewModel.swift
//  Iscra
//
//  Created by mac on 24/11/21.
//

import UIKit
import Foundation

final class ChangePasswordViewModel {
    
    var password: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    
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
        
        if Validation().textValidation(text: password, validationType: .currentPassword).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: password, validationType: .currentPassword).1))
            return
        }
        if Validation().textValidation(text: newPassword, validationType: .newPassword).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: newPassword, validationType: .newPassword).1))
            return
        }
        
        if Validation().textValidation(text: confirmPassword, validationType: .confirmPassword).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: confirmPassword, validationType: .confirmPassword).1))
            return
        }
        
        if newPassword != confirmPassword {
            view?.onAction(.requireFields(AppConstant.invalidConfirmPasswordMatch))
        } else if password == newPassword {
            view?.onAction(.requireFields(AppConstant.invalidCurrentPasswordMatch))
        } else {
            self.provider.changePassword(param: UserParams.ChangePassword(current_password: password, new_password: newPassword))
        }
    }
}

extension ChangePasswordViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                    self.view?.onAction(.changePassword(resp.message ?? ""))
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
