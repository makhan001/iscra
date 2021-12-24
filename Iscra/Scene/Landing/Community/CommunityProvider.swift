//
//  CommunityProvider.swift
//  Iscra
//
//  Created by mac on 17/12/21.
//

import Foundation

final class CommunityServiceProvider: CommunityServiceProvidable {
    private let task = UserTask()
    var delegate: CommunityServiceProvierDelegate?
    
    func fetchCommunity(param: CommunityParams.FetchCommunity) {
        WebService().StartIndicator()
        task.fetchCommunity(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
                        if err != nil {
                            self?.delegate?.completed(for: .fetchCommunity, with: resp, with: err)
                            return
                        }
                        self?.delegate?.completed(for: .fetchCommunity, with: resp, with: nil)
                    }
        }
    
    func allGroupHabit(param: CommunityParams.AllGroupHabit) {
        WebService().StartIndicator()
        task.allGroupHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .allGroupHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .allGroupHabit, with: resp, with: nil)
        }
    }
    
    func friends(param: CommunityParams.Friends) {
        WebService().StartIndicator()
        task.friends(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .friends, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .friends, with: resp, with: nil)
        }
    }
    
}

