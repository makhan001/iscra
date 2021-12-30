//
//  ShareHabitViewModel.swift
//  Iscra
//
//  Created by mac on 30/12/21.
//

import UIKit
import Foundation

final class ShareHabitViewModel {
    
    var habitId: Int = 0
    var arrFriend = [Friend]()
    var arrSelectedUsers = [Int]()
    var arrShareHabit = [ShareHabit]()
    var navigationFormCommunityDetail = false
    var sourceScreen: ShareHabitSourceScreen = .invite

    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func shareHabit() {
        self.provider.shareHabit(param: HabitParams.ShareHabit(habit_id: self.habitId, user_ids: self.arrSelectedUsers, share_type: "1"))
    }
    
    func callApiFriendList() {
        self.provider.friends(param: HabitParams.Friends(search: ""))
    }
}

extension ShareHabitViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                
                if let resp = response as? SuccessResponseModel, resp.code == 200, let friendsList = resp.data?.friends{
                   self.arrFriend = friendsList
                   self.arrFriend.sort { $0.username ?? "" < $1.username ?? "" }
                   print("self.arrFriend is \(self.arrFriend.count)")
                   self.view?.onAction(.sucessMessage(resp.message ?? ""))
               } else if let resp = response as? SuccessResponseModel, resp.code == 200 , let shareHabit = resp.data?.shareHabit{
                    self.view?.onAction(.shareHabitSucess(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
