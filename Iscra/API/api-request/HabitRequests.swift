//
//  HabitRequests.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//

import Foundation

struct HabitRequests: RequestRepresentable {
        
    var createHabit: HabitParams.CreateHabit?
    var updateHabit: HabitParams.UpdateHabit?
    var deleteHabit: HabitParams.DeleteHabit?
    var habitDetail: HabitParams.HabitDetail?
    var allHabitList: HabitParams.AllHabitList?
    var markAsComplete: HabitParams.MarkAsComplete?
    var groupInvitations: HabitParams.GroupInvitations?
    var showHabit: HabitParams.ShowHabit?
    var joinHabit: HabitParams.JoinHabit?

    let requestType: RequestType
    enum RequestType {
        case createHabit
        case updateHabit
        case deleteHabit
        case habitDetail
        case allHabitList
        case markAsComplete
        case groupInvitations
        case showHabit
        case joinHabit
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
        case is HabitParams.MarkAsComplete:
            self.markAsComplete = params as? HabitParams.MarkAsComplete
        case is HabitParams.GroupInvitations:
            self.groupInvitations = params as? HabitParams.GroupInvitations
        case is HabitParams.ShowHabit:
            self.showHabit = params as? HabitParams.ShowHabit
        case is HabitParams.JoinHabit:
            self.joinHabit = params as? HabitParams.JoinHabit

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
        case .groupInvitations:
            return "groupinvitations/invited"
        case .markAsComplete:
            return "habitmarks/mark_as_complete"
        case .showHabit:
            return "habits/show_habit"
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
        case .showHabit:
            return .body(data: encodeBody(data: showHabit))
        case .joinHabit:
            return .body(data: encodeBody(data: joinHabit))
        default:
            return .none
        }
    }
}
