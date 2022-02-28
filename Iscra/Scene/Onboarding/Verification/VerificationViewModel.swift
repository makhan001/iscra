//
//  VerificationViewModel.swift
//  Iscra
//
//  Created by mac on 22/11/21.
//

import UIKit
import Firebase
import Foundation
import FBSDKCoreKit

final class VerificationViewModel {
    
    var strText1: String = ""
    var strText2: String = ""
    var strText3: String = ""
    var strText4: String = ""
    var timerRemainingSeconds:Int = 0
    var isResendVerification: Bool = false
    weak var view: OnboardingViewRepresentable?
    let provider: OnboardingServiceProvidable
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    private func validateUserInput() {
        if (!self.strText1.isEmpty && self.strText1 != "") && (!self.strText2.isEmpty && self.strText2 != "" ) && (!self.strText3.isEmpty && self.strText3 != "") && (!self.strText4.isEmpty && self.strText4 != "") {
            self.isResendVerification = false
            self.provider.verification(param: UserParams.Verification(verification_code: strText1 + strText2 + strText3 + strText4))
        } else {
            view?.onAction(.requireFields("Please enter all charaters for verification"))
        }
    }
    
    private func resendVerification() {
        self.isResendVerification = true
        self.provider.resendVerification(param: UserParams.ResendVerification())
    }
    
    private func AnalyticsForVerification() {
        Analytics.logEvent("verified_user_count",  parameters: [
            "is_verified": UserStore.isVerify ?? false,
        ])
        AppEvents.logEvent(AppEvents.Name(rawValue: "Iscra App installs with verified_user_count"))

    }
}

extension VerificationViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType) {
        switch action {
        case .inputComplete: validateUserInput()
        case .resendVerification : resendVerification()
        default: break
        }
    }
    
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.status == true {
//                    let code =  resp.data?.verificationCode ?? 0
                    //                    let msg = (resp.message! + " code is " + String(code))
                    
                    if let isVerify =  resp.data?.isVerified {
                        UserStore.save(isVerify: isVerify)
                        self.AnalyticsForVerification()
                    }
                    self.view?.onAction(.verification(""))
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}

