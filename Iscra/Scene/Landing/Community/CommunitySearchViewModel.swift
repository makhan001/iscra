//
//  CommunitySearchViewModel.swift
//  Iscra
//
//  Created by Dr.Mac on 21/12/21.
//

import Foundation
import UIKit

final class CommunitySearchViewModel {
    
    var myGroupList = [GroupHabit]()
    let provider: CommunityServiceProvidable
    weak var view: CommunityViewRepresentable?
    var delegate: CommunityServiceProvierDelegate?
    
//    var pullToRefreshCtrl:UIRefreshControl!
//    var isRefreshing = false
    
    init(provider: CommunityServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
     func fetchCommunityList() {
        self.provider.allGroupHabit(param: CommunityParams.AllGroupHabit())
       
    }
}

extension CommunitySearchViewModel: CommunityServiceProvierDelegate{
    func completed<T>(for action: CommunityAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let groupList = resp.data?.groupHabits {
                    let arrForGroup = groupList.filter({$0.habitType == "group_habit"})
                    self.myGroupList = arrForGroup
                    self.myGroupList.sort { Int($0.createdAt!) > Int($1.createdAt!) }
                    print("arrForGroup.count is \(arrForGroup.count)")
                    print("self.groupList is \(self.myGroupList.count)")
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}

