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

    func joinHabit(param: CommunityParams.JoinHabit) {
        task.joinHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .joinHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .joinHabit, with: resp, with: nil)
        }
    }
    
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
        task.allGroupHabit(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .allGroupHabit, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .allGroupHabit, with: resp, with: nil)
        }
    }
    
    func friends(param: CommunityParams.Friends) {
        task.friends(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .friends, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .friends, with: resp, with: nil)
        }
    }
}

