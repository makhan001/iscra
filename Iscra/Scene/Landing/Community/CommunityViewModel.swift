//
//  CommunityViewModel.swift
//  Iscra
//
//  Created by mac on 20/12/21.
//

import UIKit
import Foundation

final class CommunityViewModel {
    
    var habitId: Int = 0
    var habitList = [AllHabits]()
    let provider: CommunityServiceProvidable
    weak var view: CommunityViewRepresentable?
    var delegate: CommunityServiceProvierDelegate?
    
    var pullToRefreshCtrl:UIRefreshControl!
    var isRefreshing = false
    
    init(provider: CommunityServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
     func fetchCommunityList() {
        self.provider.fetchCommunity(param: CommunityParams.FetchCommunity())
        if self.isRefreshing {
            WebService().StopIndicator()
        }
    }
}

extension CommunityViewModel: CommunityServiceProvierDelegate{
    func completed<T>(for action: CommunityAction, with response: T?, with error: APIError?) {
       
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
