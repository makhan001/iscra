//
//  CommunityRequest.swift
//  Iscra
//
//  Created by mac on 13/12/21.
//

import Foundation

struct CommunityRequest: RequestRepresentable {
        
    var joinHabit: CommunityParams.JoinHabit?
    var fetchCommunity: CommunityParams.FetchCommunity?
    var allGroupHabit: CommunityParams.AllGroupHabit?
    var friends: CommunityParams.Friends?

    let requestType: RequestType
    enum RequestType {
        case joinHabit
        case fetchCommunity
        case allGroupHabit
        case friends
    }
    
    init(requestType: RequestType) {
        self.requestType = requestType
    }
    
    init(type: RequestType, params:Codable) {
        self.requestType = type
        switch params {
        case is CommunityParams.JoinHabit:
            self.joinHabit = params as? CommunityParams.JoinHabit
        case is CommunityParams.FetchCommunity:
            self.fetchCommunity = params as? CommunityParams.FetchCommunity
        case is CommunityParams.AllGroupHabit:
            self.allGroupHabit = params as? CommunityParams.AllGroupHabit
        case is CommunityParams.Friends:
            self.friends = params as? CommunityParams.Friends
        default:break
        }
    }

    var method: HTTPSMethod {
        switch self.requestType {
        case .fetchCommunity , .allGroupHabit , .friends:
            return .get
        default:
            return .post
        }
    }
        
    var endpoint: String {
        switch self.requestType {
        case .joinHabit:
            return "joinhabits/join_habit"
        case .fetchCommunity:
            return "joinhabits/fetch_community"
        case .allGroupHabit:
            return "joinhabits​/all_group_habit"
        case .friends:
            return "joinhabits/friends"
        }
    }
    
    var parameters: Parameters {
        switch self.requestType {
        case .joinHabit:
            return .body(data: encodeBody(data: joinHabit))
        case .fetchCommunity:
            return .none
        case .allGroupHabit:
            return .none
        case .friends:
            return .none
        default:
            return .none
        }
    }
}


