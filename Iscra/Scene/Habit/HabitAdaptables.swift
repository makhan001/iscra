//
//  HabitAdaptables.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//

import Foundation

enum HabitScreenType: String {
    case createHabit
    case setTheme
    case daysSelection
    case setGroupImage
    case editHabit
}

struct WeekDays {
    var id : Int
    var shortDayname: String
    var dayname: String
    var isSelected: Bool
}

var WeakDaysArray = [WeekDays(id: 7, shortDayname: "S", dayname: "sunday", isSelected: false),
                WeekDays(id: 1, shortDayname: "M", dayname: "monday", isSelected: false),
                WeekDays(id: 2, shortDayname: "T", dayname: "tuesday", isSelected: false),
                WeekDays(id: 3, shortDayname: "W", dayname: "wednesday", isSelected: false),
                WeekDays(id: 4, shortDayname: "T", dayname: "thursday", isSelected: false),
                WeekDays(id: 5, shortDayname: "F", dayname: "friday", isSelected: false),
                WeekDays(id: 6, shortDayname: "S", dayname: "saturday", isSelected: false)]

struct HabitThemeColor {
    var id : String
    var colorHex: String
    var isSelected: Bool
}

let WeekDayNumbers: [String : Int] = [
    "monday": 0,
    "tuesday": 1,
    "wednesday": 2,
    "thursday": 3,
    "friday": 4,
    "saturday": 5,
    "sunday": 6
]

enum HabitAction {
  case joinHabit
  case habitList
  case createHabit
  case deleteHabit
  case habitDetail
  case updateHabit
  case habitCalender
  case markAsComplete
  case shareHabit
  case groupHabitDetails
  case groupHabitMembers
  case isHabitDelete(_ isDelete: Bool, _ msg:String)
  case navigateToGroupImage(_ isNavigate: Bool)
  case requireFields(_ text:String)
  case inputComplete(_ screen: HabitScreenType)
  case setTheme(_ screen: HabitScreenType)
  case setDaySelection(_ screen: HabitScreenType)
  case setGroupImage(_ screen: HabitScreenType)
  case editingDidEnd(_ field:String, _ value:String)
  case editingDidChange(_ field:String, _ value:String)
  case errorMessage(_ text:String)
  case sucessMessage(_ text:String)
  case joinHabitMessage(_ text:String)
}
protocol HabitViewRepresentable: AnyObject {
    func onAction(_ action:  HabitAction)
}
protocol HabitInputViewDelegate:AnyObject {
    func onAction(action: HabitAction, for screen: HabitScreenType)
}
protocol HabitServiceProvidable: AnyObject {
  var delegate: HabitServiceProvierDelegate? { get set }
  func joinHabit(param: HabitParams.JoinHabit)
  func habitList(param: HabitParams.AllHabitList)
  func createHabit(param: HabitParams.CreateHabit)
  func deleteHabit(param: HabitParams.DeleteHabit)
  func habitDetail(param: HabitParams.HabitDetail)
  func updateHabit(param: HabitParams.UpdateHabit)
  func habitCalender(param: HabitParams.HabitCalender)
  func markAsComplete(param: HabitParams.MarkAsComplete)
  func groupHabitMembers(param: HabitParams.GroupHabitMembers)
  func groupHabitDetails(param: HabitParams.GroupHabitDetails)
}
protocol HabitServiceProvierDelegate: AnyObject {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?)
}
