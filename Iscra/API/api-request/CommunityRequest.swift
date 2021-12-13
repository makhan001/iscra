//
//  CommunityRequest.swift
//  Iscra
//
//  Created by mac on 13/12/21.
//

import Foundation

struct CommunityRequest: RequestRepresentable {
        
    var createHabit: HabitParams.CreateHabit?
    var updateHabit: HabitParams.UpdateHabit?
    var deleteHabit: HabitParams.DeleteHabit?
    var habitDetail: HabitParams.HabitDetail?
    var allHabitList: HabitParams.AllHabitList?
    var groupInvitations: HabitParams.GroupInvitations?
    var markAsComplete: HabitParams.MarkAsComplete?

    let requestType: RequestType
    enum RequestType {
        case createHabit
        case updateHabit
        case deleteHabit
        case habitDetail
        case allHabitList
        case groupInvitations
        case markAsComplete
    }
    
    init(requestType: RequestType) {
        self.requestType = requestType
    }
    
    init(type: RequestType, params:Codable) {
        self.requestType = type
        switch params {
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
        case is HabitParams.GroupInvitations:
            self.groupInvitations = params as? HabitParams.GroupInvitations
        case is HabitParams.MarkAsComplete:
            self.markAsComplete = params as? HabitParams.MarkAsComplete
        default:break
        }
    }
    
    var method: HTTPSMethod {
        switch self.requestType {
        case .allHabitList:
            return .get
        case .updateHabit:
            return .put
        case .deleteHabit:
            return .delete
        default:
            return .post
        }
    }
    
    var endpoint: String {
        switch self.requestType {
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
        case .groupInvitations:
            return "groupinvitations/invited"
        case .markAsComplete:
            return "habitmarks/mark_as_complete"
        }
    }
    
    var parameters: Parameters {
        switch self.requestType {
        case .createHabit:
            return .body(data: encodeBody(data: createHabit))
        case .allHabitList:
            return .none
        case .updateHabit:
            return .body(data: encodeBody(data: updateHabit))
        case .deleteHabit:
            return .body(data: encodeBody(data: deleteHabit))
        case .habitDetail:
            return .body(data: encodeBody(data: habitDetail))
        case .groupInvitations:
            return .body(data: encodeBody(data: groupInvitations))
        case .markAsComplete:
            return .body(data: encodeBody(data: markAsComplete))
        default:
            return .none
        }
    }
}
