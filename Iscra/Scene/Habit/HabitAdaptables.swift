//
//  HabitAdaptables.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//

import Foundation

enum HabitScreenType: String {
    case createHabit
}

enum HabitAction {
    case createHabit
    case deleteHabit
    case habitDetail
    case habitList
    case updateHabit
    case requireFields(_ text:String)
    case inputComplete(_ screen: HabitScreenType)
    case editingDidEnd(_ field:String, _ value:String)
    case editingDidChange(_ field:String, _ value:String)
    case errorMessage(_ text:String)
}
protocol HabitViewRepresentable: AnyObject {
    func onAction(_ action:  HabitAction)
}
protocol HabitInputViewDelegate:AnyObject {
    func onAction(action: HabitAction, for screen: HabitScreenType)
}
protocol HabitServiceProvidable: AnyObject {
    var  delegate: HabitServiceProvierDelegate? { get set }
    func createHabit(param: HabitParams.CreateHabit)
    func deleteHabit(param: HabitParams.DeleteHabit)
    func habitDetail(param: HabitParams.HabitDetail)
    func habitList(param: HabitParams.AllHabitList)
    func updateHabit(param: HabitParams.UpdateHabit)
}
protocol HabitServiceProvierDelegate: AnyObject {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?)
}
