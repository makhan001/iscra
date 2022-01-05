//
//  SubscriptionViewModel.swift
//  Iscra
//
//  Created by m@k on 04/01/22.
//

import Foundation

final class SubscriptionViewModel {
    
    var sourceScreen: SubscriptionSourceScreen = .myAccount
    
    let provider: OnboardingServiceProvidable
    weak var view: OnboardingViewRepresentable?
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
}

extension SubscriptionViewModel: OnboardingServiceProvierDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                    self.view?.onAction(.login("", resp.data?.loginData?.isVerified ?? false))
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
