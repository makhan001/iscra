//
//  CommunityViewModel.swift
//  Iscra
//
//  Created by mac on 20/12/21.
//

import UIKit
import Foundation

final class CommunityViewModel {
    
    var colorTheme: String = "#ff7B86EB"
    var habitId: Int = 0
    var myGroups = [GroupHabit]()
    var habitMarks = [HabitMark]()
    var myInvitaions = [Invitaion]()
    var groupMembers = [GroupMember]()
    
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
    
    func callApiGroupInvitation() {
        // self.provider.groupInvitations(param: CommunityParams.GroupInvitations(habit_id: self.habit_id, user_ids: ["1"]))
    }
}

extension CommunityViewModel: CommunityServiceProvierDelegate{
    func completed<T>(for action: CommunityAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                WebService().StopIndicator()
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let myGroups = resp.data?.groupHabits, let myInvitaions = resp.data?.invitaions {
                    self.myGroups = myGroups
                    self.myGroups.sort { Int($0.createdAt ?? 0) > Int($1.createdAt ?? 0) }
                    self.myInvitaions = myInvitaions
                    self.myInvitaions.sort { Int($0.createdAt!) > Int($1.createdAt!) }
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
