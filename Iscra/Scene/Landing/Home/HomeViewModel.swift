//
//  HomeViewModel.swift
//  Iscra
//
//  Created by mac on 26/11/21.
//


import UIKit
import Foundation

final class HomeViewModel {
    
    var habitId: Int = 0
    var isRefreshing = false
    var colorTheme: String = "#ff7B86EB"
    var pullToRefreshCtrl:UIRefreshControl!
    var habitList = [AllHabits]()
    var habitMarks = [HabitMark]()
    var groupMembers = [GroupMember]()
    let sourceScreen: SubscriptionSourceScreen = .login
    
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }

    func fetchHabitList() {
        self.provider.habitList(param: HabitParams.AllHabitList())
        if self.isRefreshing {
            WebService().StopIndicator()
        }
    }
    
    func deleteHabit(id: String) {
        self.provider.deleteHabit(param: HabitParams.DeleteHabit(id: id))
    }
    
    func getSubscription() {
        self.provider.getSubscription(param: HabitParams.GetSubscription())
    }
    
    func updateSubscription(_ isSubscribed: Bool) {
        self.provider.updateSubscription(param: HabitParams.UpdateSubscription(is_subscribed: isSubscribed))
    }
    
    func apiMarkAsComplete(objHabitMark: HabitMark) {
        let timestamp = String(format: "%.0f", NSDate().timeIntervalSince1970)
        let id  = objHabitMark.habitID ?? 0
        if  objHabitMark.isCompleted == false &&  objHabitMark.habitDay?.toDouble.habitDate == Date().currentHabitDate {
           self.provider.markAsComplete(param: HabitParams.MarkAsComplete(habit_id: String(id), habit_day: String(timestamp) , is_completed: "true"))
        } else if  objHabitMark.isCompleted == true &&  objHabitMark.habitDay?.toDouble.habitDate == Date().currentHabitDate {
            self.view?.onAction(.errorMessage("You have already marked this habit as completed!!"))
        }else{
            self.view?.onAction(.errorMessage("You can't mark this habit as complete, since day is already passed!!"))
        }
    }
}

extension HomeViewModel: HabitServiceProvierDelegate {
    
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                    switch action {
                    case .habitList:
                        if self.isRefreshing {
                            self.habitList.removeAll()
                        }
                        self.isRefreshing = false
                        self.pullToRefreshCtrl.endRefreshing()
                        self.habitList = resp.data?.habits ?? self.habitList
                        self.habitList.sort { Int($0.createdAt!) > Int($1.createdAt!) }
                        self.view?.onAction(.sucessMessage(resp.message ?? ""))
                        
                    case .deleteHabit:
                        self.view?.onAction(.isHabitDelete(true, resp.message ?? ""))
                    
                    case .markAsComplete:
                    self.view?.onAction(.markAsCompleteSucess(resp.message ?? ""))
                        
                    case .getSubscription:
                        let transactionDate = resp.data?.getSubscription?.transactionDate?.toDouble.date.addDays(days: 29) ?? 0.0
                        let currentDate = Date().timeIntervalSince1970
                            if transactionDate <= currentDate {
                                self.updateSubscription(false)
                            }
                    case .updateSubscription:
                        UserStore.save(primeUser: resp.data?.user?.isSubscribed)
                        self.view?.onAction(.subscription)
                    default:
                        self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}
