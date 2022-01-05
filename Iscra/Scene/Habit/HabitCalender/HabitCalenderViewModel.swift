//
//  HabitCalenderViewModel.swift
//  Iscra
//
//  Created by mac on 06/12/21.
//

import UIKit
import Foundation

final class HabitCalenderViewModel {
    
    var habitId: Int = 0
    var habitMonth: String = ""
    var longestStreak: Int?
    var userId: String = UserStore.userID ?? ""
    var isfromGroupHabitCalendar: Bool = false
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    var objHabitDetail: HabitDetails?
    var arrHabitCalender: [HabitCalender]?

    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
     func getMonthlyHabitDetail() {
        print("self.habitId is in HabitCalenderViewModel \(String(habitId)) and self.userId is \(self.userId) and self.habitMonth is \(self.habitMonth) ")
        self.provider.habitCalender(param: HabitParams.HabitCalender(habit_id: self.habitId, user_id: Int(self.userId), habit_month: Int(self.habitMonth)))
    }
    
    func fetchHabitDetail() {
        print("self.habitId is in HabitCalenderViewModel \(String(habitId)) and self.userId is \(self.userId) ")
      // self.provider.showHabit(param: HabitParams.ShowHabit(habit_id: String(self.habitId), user_id: self.userId))
        self.provider.habitDetail(param: HabitParams.HabitDetail(habit_id: self.habitId, user_id: Int(self.userId)))
    }
    
    func deleteHabit(habitId: String) {
        self.provider.deleteHabit(param: HabitParams.DeleteHabit(id: habitId))
    }
    
    func apiMarkAsComplete() {
        let timestamp = String(format: "%.0f", NSDate().timeIntervalSince1970)
        self.provider.markAsComplete(param: HabitParams.MarkAsComplete(habit_id: String(self.habitId), habit_day: String(timestamp) , is_completed: "true"))
    }
    
    func monthName(monthNumber:Int) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MMMM"
        let month = fmt.monthSymbols[monthNumber - 1]
        return month
    }
}

extension HabitCalenderViewModel: HabitServiceProvierDelegate {

    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let objHabitDetail = resp.data?.habitDetails {
                    self.objHabitDetail = objHabitDetail
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let arrHabitCalender = resp.data?.habitCalender, let longestStreak = resp.data?.longestStreak {
                    self.arrHabitCalender = arrHabitCalender
                    self.longestStreak = longestStreak
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let _ = resp.data?.habitMark{
                    self.getMonthlyHabitDetail()
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                    NotificationCenter.default.post(name: .MarkAsComplete, object: nil)
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let status = resp.status {
                     if status == true {
                         print("data is nil")
                         self.view?.onAction(.isHabitDelete(true, resp.message ?? ""))
                     }
                 }  else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
