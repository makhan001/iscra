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

    let requestType: RequestType
    enum RequestType {
        case createHabit
        case updateHabit
        case deleteHabit
        case habitDetail
        case allHabitList
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
            return "habits"
        case .allHabitList:
            return "habits"
        case .updateHabit:
            return "habits/edit"
        case .deleteHabit:
            return "habits/delete"
        case .habitDetail:
            return "habits/groupdetails"
        }
    }
    
    var parameters: Parameters {
        switch self.requestType {
        case .createHabit:
            return .body(data: encodeBody(data: createHabit))
        case .allHabitList:
            return .body(data: encodeBody(data: allHabitList))
        case .updateHabit:
            return .body(data: encodeBody(data: updateHabit))
        case .deleteHabit:
            return .body(data: encodeBody(data: deleteHabit))
        case .habitDetail:
            return .body(data: encodeBody(data: allHabitList))
        default:
            return .none
        }
    }
}
