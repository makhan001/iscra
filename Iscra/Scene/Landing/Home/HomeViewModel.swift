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
    var pullToRefreshCtrl:UIRefreshControl!
    var isRefreshing = false

    var colorTheme: String = "#ff7B86EB"
    var habitList = [AllHabits]()
    var habitMarks = [HabitMark]()
    var groupMembers = [GroupMember]()
    
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
                        
                    default:
                        self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))

                    }
                }
            }
        }
    }
}
