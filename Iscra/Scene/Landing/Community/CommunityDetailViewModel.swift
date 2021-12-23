//
//  CommunityDetailViewModel.swift
//  Iscra
//
//  Created by mac on 23/12/21.
//

import UIKit
import Foundation

final class CommunityDetailViewModel {
    
    var habitId: Int = 0
    var userId: String = ""
    var habitList = [AllHabits]()
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    var pullToRefreshCtrl:UIRefreshControl!
    var isRefreshing = false
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
     func fetchHabitDetail() {
        self.provider.showHabit(param: HabitParams.ShowHabit(habit_id: String(self.habitId), user_id: self.userId))
     }
    
    func joinHabit() {
        self.provider.joinHabit(param: HabitParams.JoinHabit(habit_id: String(self.habitId)))
    }
}

extension CommunityDetailViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
     
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let habitList = resp.data?.habits {
                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
    
//    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
//        DispatchQueue.main.async {
//            WebService().StopIndicator()
//            if error != nil {
//                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
//            } else {
//                if let resp = response as? SuccessResponseModel, resp.code == 200, let habitList = resp.data?.habits {
//
//                    if self.isRefreshing{
//                        self.habitList.removeAll()
//                    }
//                    self.isRefreshing = false
//                    self.pullToRefreshCtrl.endRefreshing()
//
//                    //  self.habitList.sort(by: {$0.createdAt!.compare($1.createdAt!) == .orderedDescending })
//                   self.habitList = habitList
//                     self.habitList.sort { Int($0.createdAt!) > Int($1.createdAt!) }
//                    self.view?.onAction(.sucessMessage(resp.message ?? ""))
//
//                 //   print("obj habitDay is \(self.habitList[0].habitMarks?[0].habitDay)")
//
//                } else if let resp = response as? SuccessResponseModel, resp.code == 200, let status = resp.status {
//                   // self.view?.onAction(.isHabitDelete(true))
//                    if status == true {
//                        print("data is nil")
//                      //  self.view?.onAction(.isHabitDelete(true))
//                        self.view?.onAction(.isHabitDelete(true, resp.message ?? ""))
//                    }
//                } else {
//                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
//                }
//            }
//        }
//    }
}
