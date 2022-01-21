//
//  SubscriptionViewModel.swift
//  Iscra
//
//  Created by m@k on 04/01/22.
//

import StoreKit
import Foundation

final class SubscriptionViewModel {
    
    var products = [SKProduct]()
    var sourceScreen: SubscriptionSourceScreen = .myAccount
    
    let provider: OnboardingServiceProvidable
    weak var view: OnboardingViewRepresentable?
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func getProducts() {
        Products.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
                self.view?.onAction(.products)
            } else {
                self.view?.onAction(.errorMessage("No products found"))
            }
        }
    }
    
    func buyProduct(_ product: SKProduct) {
        if IAPHelper.canMakePayments() {
            Products.store.buyProduct(product)
        } else {}
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
