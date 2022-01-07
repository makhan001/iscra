//
//  InviteFriendViewModel.swift
//  Iscra
//
//  Created by mac on 07/01/22.
//

import UIKit
import Foundation

final class InviteFriendViewModel {
    
    var habitId: Int = 0
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func shareHabit() {
          self.provider.shareHabit(param: HabitParams.ShareHabit(habit_id: self.habitId, user_ids: []))
    }
}

extension InviteFriendViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 , let _ = resp.data?.shareHabit{
                    WebService().StopIndicator()
                    self.view?.onAction(.shareHabitSucess(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
