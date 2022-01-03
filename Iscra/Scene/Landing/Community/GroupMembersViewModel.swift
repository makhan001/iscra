//
//  GroupMembersViewModel.swift
//  Iscra
//
//  Created by mac on 29/12/21.
//

import UIKit
import Foundation

final class GroupMembersViewModel {
    
    var habitId: Int = 0
    var arrGroupHabitMembers = [GroupHabitMember]()

    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func fetchGroupMembers() {
        self.provider.groupHabitMembers(param: HabitParams.GroupHabitMembers(habit_id: self.habitId))
    }
}

extension GroupMembersViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let arrGroupHabitMembers = resp.data?.groupHabitMembers{
                    self.arrGroupHabitMembers = arrGroupHabitMembers
                    self.arrGroupHabitMembers.sort { $0.username ?? "" < $1.username ?? "" }
                    print("self.arrGroupHabitMembers is \(self.arrGroupHabitMembers.count)")
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
