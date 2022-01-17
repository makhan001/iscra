//
//  CommunitySearchViewModel.swift
//  Iscra
//
//  Created by mac on 22/12/21.
//

import UIKit
import Foundation

final class CommunitySearchViewModel {
    
    var habitId: Int = 0
    var strSearchText = ""
    var isSearching:Bool=false
    var arrFriend = [Friend]()
    var arrGroupList = [AllGroupHabit]()
    var arrGroupHabitMembers = [GroupHabitMember]()

    let provider: CommunityServiceProvidable
    weak var view: CommunityViewRepresentable?
    var delegate: CommunityServiceProvierDelegate?
    
    init(provider: CommunityServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func callApiFriendList() {
        self.provider.friends(param: CommunityParams.Friends(search: self.strSearchText))
        if self.isSearching {
            WebService().StopIndicator()
        }
    }
    
    func callApiAllGroupHabit() {
        self.provider.allGroupHabit(param: CommunityParams.AllGroupHabit(search: self.strSearchText))
        if self.isSearching {
            WebService().StopIndicator()
        }
    }
    
    func fetchGroupMembers() {
        self.provider.groupHabitMembers(param: CommunityParams.GroupHabitMembers(habit_id: self.habitId))
    }
}

extension CommunitySearchViewModel: CommunityServiceProvierDelegate {
    func completed<T>(for action: CommunityAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let allGroupList = resp.data?.allGroupHabits{
                    self.arrFriend.removeAll()
                    self.arrGroupList = allGroupList
                    self.arrFriend.sort { String($0.createdAt!) > String($1.createdAt!) }
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let friendsList = resp.data?.friends{
                    self.arrGroupList.removeAll()
                    self.arrFriend = friendsList
                    self.arrFriend = self.arrFriend.sorted(by: { (Obj1, Obj2) -> Bool in
                          let Obj1_Name = Obj1.username ?? ""
                          let Obj2_Name = Obj2.username ?? ""
                          return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
                       })
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let arrGroupHabitMembers = resp.data?.groupHabitMembers{
                    self.arrGroupHabitMembers = arrGroupHabitMembers
                    let arrIsUserAvailable = self.arrGroupHabitMembers.filter({$0.id == Int(UserStore.userID ?? "")})
                                                                if arrIsUserAvailable.count == 0 {
                                                                    print("is not Exist")
                                                                    self.view?.onAction(.isUserAvailable(false))
                                                                } else {
                                                                    print("isExist")
                                                                    self.view?.onAction(.isUserAvailable(true))
                                                                }
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
