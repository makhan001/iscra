//
//  CommunityViewModel.swift
//  Iscra
//
//  Created by mac on 20/12/21.
//

import UIKit
import Foundation

final class CommunityViewModel {
    
    var arrMyGroupList = [GroupHabit]()
    var arrInvitaions = [Invitaion]()
    
    let provider: CommunityServiceProvidable
    weak var view: CommunityViewRepresentable?
    var delegate: CommunityServiceProvierDelegate?
    
    init(provider: CommunityServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func fetchCommunityList() {
        self.provider.fetchCommunity(param: CommunityParams.FetchCommunity())
    }
}

extension CommunityViewModel: CommunityServiceProvierDelegate{
    func completed<T>(for action: CommunityAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let groupList = resp.data?.groupHabits, let invitaionsList = resp.data?.invitaions{
                    //                    let arrForGroup = groupList.filter({$0.habitType == "group_habit"})
                    //                    self.myGroupList = arrForGroup
                    self.arrMyGroupList = groupList
                    self.arrMyGroupList.sort { Int($0.createdAt!) > Int($1.createdAt!) }
                    print("self.groupList is \(self.arrMyGroupList.count)")
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                    
                    self.arrInvitaions = invitaionsList
                     self.arrInvitaions.sort { Int($0.createdAt!) > Int($1.createdAt!) }
                    print("self.arrInvitaions is \(self.arrInvitaions.count)")
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                }else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
