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
    var arrGroupHabitMembers = [GroupHabitMember]()
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
    
    func fetchGroupMembers() {
        self.provider.groupHabitMembers(param: HabitParams.GroupHabitMembers(habit_id: self.habitId))
    }
}

extension ShareHabitViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                
                if let resp = response as? SuccessResponseModel, resp.code == 200, let arrGroupHabitMembers = resp.data?.groupHabitMembers {
                    self.arrGroupHabitMembers = arrGroupHabitMembers
                    self.callApiFriendList()
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let friendsList = resp.data?.friends {
                    self.arrFriend = friendsList.filter { (friend) -> Bool in
                        let arruserIds = self.arrGroupHabitMembers.compactMap { $0.id }
                        return !arruserIds.contains(friend.id ?? 0)
                    }
                    self.arrFriend = self.arrFriend.sorted(by: { (Obj1, Obj2) -> Bool in
                          let Obj1_Name = Obj1.username ?? ""
                          let Obj2_Name = Obj2.username ?? ""
                          return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
                       })
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else if let resp = response as? SuccessResponseModel, resp.code == 200 , let _ = resp.data?.shareHabit{
                    WebService().StopIndicator()
                    self.view?.onAction(.shareHabitSucess(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
