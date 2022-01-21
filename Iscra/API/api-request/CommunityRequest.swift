//
//  CommunityRequest.swift
//  Iscra
//
//  Created by mac on 13/12/21.
//

import Foundation

struct CommunityRequest: RequestRepresentable {
        
    var fetchCommunity: CommunityParams.FetchCommunity?
    var allGroupHabit: CommunityParams.AllGroupHabit?
    var friends: CommunityParams.Friends?
    var groupHabitMembers: CommunityParams.GroupHabitMembers?

    let requestType: RequestType
    enum RequestType {
        case fetchCommunity
        case allGroupHabit
        case friends
        case groupHabitMembers
    }
    
    init(requestType: RequestType) {
        self.requestType = requestType
    }
    
    init(type: RequestType, params:Codable) {
        self.requestType = type
        switch params {
        case is CommunityParams.FetchCommunity:
            self.fetchCommunity = params as? CommunityParams.FetchCommunity
        case is CommunityParams.AllGroupHabit:
            self.allGroupHabit = params as? CommunityParams.AllGroupHabit
        case is CommunityParams.Friends:
            self.friends = params as? CommunityParams.Friends
        case is CommunityParams.GroupHabitMembers:
            self.groupHabitMembers = params as? CommunityParams.GroupHabitMembers
        default:break
        }
    }

    var method: HTTPSMethod {
        switch self.requestType {
        case .fetchCommunity :
            return .get
        default:
            return .post
        }
    }
        
    var endpoint: String {
        switch self.requestType {
        case .fetchCommunity:
            return "joinhabits/fetch_community"
        case .allGroupHabit:
            return "joinhabits/all_group_habit"
        case .friends:
            return "joinhabits/friends"
        case .groupHabitMembers:
            return "habits/group_habit_members"
        }
    }
    
    var parameters: Parameters {
        switch self.requestType {
        case .fetchCommunity:
            return .none
        case .allGroupHabit:
            return  .body(data: encodeBody(data: allGroupHabit))
        case .friends:
            return  .body(data: encodeBody(data: friends))
        case .groupHabitMembers:
            return .body(data: encodeBody(data: groupHabitMembers))
        default:
            return .none
        }
    }
}


