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
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    var objHabitDetail: HabitDetails?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
     func getHabitDetail() {
        print("self.habitId is in HabitCalenderViewModel \(String(habitId))")
       // self.provider.habitDetail(param: HabitParams.HabitDetail(id: String(self.habitId)))
        self.provider.habitDetail(param: HabitParams.HabitDetail(id: String(self.habitId), user_id: "", habit_month: ""))
    }
    
    func deleteHabit(habitId: String) {
        self.provider.deleteHabit(param: HabitParams.DeleteHabit(id: habitId))
    }
    
    func apiMarkAsComplete() {
        let timestamp = String(format: "%.0f", NSDate().timeIntervalSince1970)
        self.provider.markAsComplete(param: HabitParams.MarkAsComplete(habit_id: String(self.habitId), habit_day: String(timestamp) , is_completed: "true"))
    }
}

extension HabitCalenderViewModel: HabitServiceProvierDelegate {

    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 , let objGroupDetails = resp.data?.habitDetails{
                    self.objHabitDetail = objGroupDetails
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))                    
                }else if let resp = response as? SuccessResponseModel, resp.code == 200 , let _ = resp.data?.habitMark{
                    self.getHabitDetail()
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                }else if let resp = response as? SuccessResponseModel, resp.code == 200, let status = resp.status {
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
