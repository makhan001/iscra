//
//  HabitAdaptables.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//

import Foundation

//enum HabitScreenType:  String {
//    case signup
//    case login
//    case verification
//    case forgotPassword
//    case changePassword
//}
enum HabitAction {
   // case inputComplete(_ screen:  HabitScreenType)
//    case editingDidEnd(_ field: String, _ value: String)
//    case editingDidChange(_ field: String, _ value: String)
//    case requireFields(_ text: String)
    case createHabit
    case deleteHabit
    case habitDetail
    case habitList
    case updateHabit
}
//protocol InputFieldAlertDelegate: AnyObject {
//    func userInput(_ text:  String)
//}
//protocol InputViewDelegate: AnyObject {
//    func onAction(action:  HabitAction, for screen:  HabitScreenType)
//}

protocol HabitViewRepresentable: AnyObject {
    func onAction(_ action:  HabitAction)
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
