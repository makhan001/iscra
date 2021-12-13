//
//  InviteFriendViewModel.swift
//  Iscra
//
//  Created by Dr.Mac on 13/12/21.
//

import Foundation
import UIKit

final class InviteFriendViewModel {
    
    var habit_id: String = ""
    weak var view: HabitViewRepresentable?
    let provider: HabitServiceProvidable
    var delegate: HabitServiceProvierDelegate?

    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
        delegate = self
    }
    
     func callApiGroupInvitation() {
        self.provider.groupInvitations(param: HabitParams.GroupInvitations(habit_id: self.habit_id))
    }
}

extension InviteFriendViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                    let code =  resp.data?.url
                    let msg = (resp.message! + " code is " + code!)
                 //   self.view?.onAction(.groupInvitations(msg))
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
