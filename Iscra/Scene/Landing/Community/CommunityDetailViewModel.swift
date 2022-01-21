//
//  CommunityDetailViewModel.swift
//  Iscra
//
//  Created by mac on 23/12/21.
//

import UIKit
import Foundation

final class CommunityDetailViewModel {
    
    var habitId: Int = 0
    var userId: String = ""
    var objGroupHabitDetails: GroupHabitDetails?
    
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
     func fetchHabitDetail() {        
        self.provider.groupHabitDetails(param: HabitParams.GroupHabitDetails(habit_id: self.habitId))
     }
    
    func joinHabit() {
        self.provider.joinHabit(param: HabitParams.JoinHabit(habit_id: String(self.habitId)))
    }
}

extension CommunityDetailViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
     
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let groupHabitDetails = resp.data?.groupHabitDetails {
                    self.objGroupHabitDetails = groupHabitDetails
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let _ = resp.status, let _ = resp.data?.joinHabit {
                    self.view?.onAction(.joinHabitMessage(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
