//
//  HomeViewModel.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//

import UIKit
import Foundation

final class HomeViewModel {
    
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    private func validateUserInput() {
        
        self.provider.habitList(param: HabitParams.AllHabitList())
        
    }
}

extension HomeViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                //  self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                //                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                //                    self.view?.onAction(.login(resp.message ?? "", resp.data?.loginData?.isVerified ?? false))
                //                } else {
                //                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                //                }
            }
        }
    }
}

