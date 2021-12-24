//
//  CommunitySearchViewModel.swift
//  Iscra
//
//  Created by mac on 22/12/21.
//

import UIKit
import Foundation

final class CommunitySearchViewModel {
    
    var arrGroupList = [AllGroupHabit]() //[GroupHabit]()
    var arrFriend = [Friend]()
    var strSearchText = ""
    var isSearching:Bool=false
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
                    print("self.arrGroupList is \(self.arrGroupList.count)")
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let friendsList = resp.data?.friends{
                    self.arrGroupList.removeAll()
                    self.arrFriend = friendsList
                    self.arrFriend.sort { $0.username ?? "" < $1.username ?? "" }
                    print("self.arrFriend is \(self.arrFriend.count)")
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
