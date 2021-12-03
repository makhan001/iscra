//
//  HomeViewModel.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//


import UIKit
import Foundation

final class HomeViewModel {
    
   // var habitId: String = ""
    var habitList = [AllHabits]()
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?

    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
     func fetchHabitList() {
        self.provider.habitList(param: HabitParams.AllHabitList())
    }
    
    func deleteHabit(habitId: String) {
        self.provider.deleteHabit(param: HabitParams.DeleteHabit(id: habitId))
   }
}

extension HomeViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let habitList = resp.data?.habits {
                    self.habitList = habitList
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let status = resp.status {
                   // self.view?.onAction(.isHabitDelete(true))
                    if status == true {
                        print("data is nil")
                      //  self.view?.onAction(.isHabitDelete(true))
                        self.view?.onAction(.isHabitDelete(true, resp.message ?? ""))
                    }
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
