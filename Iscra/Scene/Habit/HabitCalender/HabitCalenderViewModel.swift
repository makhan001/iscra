//
//  HabitCalenderViewModel.swift
//  Iscra
//
//  Created by mac on 06/12/21.
//

import UIKit
import Foundation

final class HabitCalenderViewModel {
    
    var habitId: Int = 0
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    var objHabitDetail: AllHabits?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
     func getHabitDetail() {
        print("self.habitId is in HabitCalenderViewModel \(String(habitId))")
        self.provider.habitDetail(param: HabitParams.HabitDetail(id: String(self.habitId)))
    }
}

extension HabitCalenderViewModel: HabitServiceProvierDelegate {

    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                    self.objHabitDetail = resp.data?.groupDetails
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))                    
                }  else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}