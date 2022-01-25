//
//  HabitRequests.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//

import Foundation

struct HabitRequests: RequestRepresentable {
    
    var friends: HabitParams.Friends?
    var joinHabit: HabitParams.JoinHabit?
    var shareHabit: HabitParams.ShareHabit?
    var createHabit: HabitParams.CreateHabit?
    var updateHabit: HabitParams.UpdateHabit?
    var deleteHabit: HabitParams.DeleteHabit?
    var habitDetail: HabitParams.HabitDetail?
    var allHabitList: HabitParams.AllHabitList?
    var habitCalender: HabitParams.HabitCalender?
    var markAsComplete: HabitParams.MarkAsComplete?
    var getSubscription: HabitParams.GetSubscription?
    var groupHabitDetails: HabitParams.GroupHabitDetails?
    var groupHabitMembers: HabitParams.GroupHabitMembers?
    var updateSubscription: HabitParams.UpdateSubscription?
 
    let requestType: RequestType
    enum RequestType {
        case joinHabit
        case createHabit
        case updateHabit
        case deleteHabit
        case habitDetail
        case allHabitList
        case habitCalender
        case markAsComplete
        case shareHabit
        case groupHabitDetails
        case groupHabitMembers
        case friends
        case getSubscription
        case updateSubscription
    }
    
    init(requestType: RequestType) {
        self.requestType = requestType
    }
    
    init(type: RequestType, params:Codable) {
        self.requestType = type
        switch params {
        case is HabitParams.JoinHabit:
            self.joinHabit = params as? HabitParams.JoinHabit
        case is HabitParams.CreateHabit:
            self.createHabit = params as? HabitParams.CreateHabit
        case is HabitParams.UpdateHabit:
            self.updateHabit = params as? HabitParams.UpdateHabit
        case is HabitParams.DeleteHabit:
            self.deleteHabit = params as? HabitParams.DeleteHabit
        case is HabitParams.HabitDetail:
            self.habitDetail = params as? HabitParams.HabitDetail
        case is HabitParams.AllHabitList:
            self.allHabitList = params as? HabitParams.AllHabitList
        case is HabitParams.HabitCalender:
            self.habitCalender = params as? HabitParams.HabitCalender
        case is HabitParams.MarkAsComplete:
            self.markAsComplete = params as? HabitParams.MarkAsComplete
        case is HabitParams.ShareHabit:
            self.shareHabit = params as? HabitParams.ShareHabit
        case is HabitParams.GroupHabitDetails:
            self.groupHabitDetails = params as? HabitParams.GroupHabitDetails
        case is HabitParams.GroupHabitMembers:
            self.groupHabitMembers = params as? HabitParams.GroupHabitMembers
        case is HabitParams.Friends:
            self.friends = params as? HabitParams.Friends
        case is HabitParams.UpdateSubscription:
            self.updateSubscription = params as? HabitParams.UpdateSubscription
        case is HabitParams.GetSubscription:
            self.getSubscription = params as? HabitParams.GetSubscription
        default:break
        }
    }
    
    var method: HTTPSMethod {
        switch self.requestType {
        case .allHabitList:
            return .get
        case .getSubscription:
            return .get
        case .updateHabit:
            return .put
        case .updateSubscription:
            return .put
        case .deleteHabit:
            return .delete
        default:
            return .post
        }
    }
    
    var endpoint: String {
        switch self.requestType {
        case .joinHabit:
            return "joinhabits/join_habit"
        case .createHabit:
            return "habits/add_habit"
        case .allHabitList:
            return "habits/fetch_habit"
        case .updateHabit:
            return "habits/edit"
        case .deleteHabit:
            return "habits/delete"
        case .habitDetail:
            return "habits/habit_details"
        case .shareHabit:
            return "sendinvites/share_habit"
        case .markAsComplete:
            return "habitmarks/mark_as_complete"
        case .habitCalender:
            return "habits/habit_calender"
        case .groupHabitDetails:
            return "habits/group_habit_details"
        case .groupHabitMembers:
            return "habits/group_habit_members"
        case .friends:
            return "joinhabits/friends"
        case .updateSubscription:
            return "users/update"
        case .getSubscription:
            return "subscribe/get_subscription"
        }
    }

    var parameters: Parameters {
        switch self.requestType {
        case .createHabit:
            return .body(data: encodeBody(data: createHabit))
        case .allHabitList:
            return .none
        case .getSubscription:
            return .none
        case .updateHabit:
            return .body(data: encodeBody(data: updateHabit))
        case .deleteHabit:
            return .body(data: encodeBody(data: deleteHabit))
        case .habitDetail:
            return .body(data: encodeBody(data: habitDetail))
        case .shareHabit:
            return .body(data: encodeBody(data: shareHabit))
        case .markAsComplete:
            return .body(data: encodeBody(data: markAsComplete))
        case .habitCalender:
            return .body(data: encodeBody(data: habitCalender))
        case .joinHabit:
            return .body(data: encodeBody(data: joinHabit))
        case .groupHabitDetails:
            return .body(data: encodeBody(data: groupHabitDetails))
        case .groupHabitMembers:
            return .body(data: encodeBody(data: groupHabitMembers))
        case .friends:
            return  .body(data: encodeBody(data: friends))
        case .updateSubscription:
            return  .body(data: encodeBody(data: updateSubscription))
        default:
            return .none
        }
    }
}
