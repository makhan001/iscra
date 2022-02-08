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
            guard let weakSelf = self else { return }
            if success {
                weakSelf.products = products!
                weakSelf.view?.onAction(.products)
            } else {
                weakSelf.view?.onAction(.errorMessage("No products found"))
            }
        }
    }
    
    func buyProduct(_ product: SKProduct) {
        if IAPHelper.canMakePayments() {
            Products.store.buyProduct(product)
        } else {}
    }
    
    func subscription(type:String, amount:String, identifier:String) {
        provider.subscription(param: UserParams.Subscription(user_id: Int(UserStore.userID ?? "0"), transaction_date: Int(Date().timeIntervalSince1970), transaction_type: type, transaction_amount: amount, transaction_identifier: identifier))
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
                    self.view?.onAction(.subscription)
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
