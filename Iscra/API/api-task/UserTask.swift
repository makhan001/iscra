//
//  UserTask.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 14/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import UIKit

final class UserTask {
    private let dispatcher = SessionDispatcher()
    
    func signup<T:Codable>(params: UserParams.Signup, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .signup, params: params), modeling: responseModel, completion: completion)
    }
    
    func login<T:Codable>(params: UserParams.Login, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .login, params: params), modeling: responseModel, completion: completion)
    }

    func forgotPassword<T:Codable>(params: UserParams.ForgotPassword, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .forgotPassword, params: params), modeling: responseModel, completion: completion)
    }

    func changePassword<T:Codable>(params: UserParams.ChangePassword, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .changePassword, params: params), modeling: responseModel, completion: completion)
    }

    func socialLogin<T:Codable>(params: UserParams.SocialLogin, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .socialLogin, params: params), modeling: responseModel, completion: completion)
    }
    
    func verification<T:Codable>(params: UserParams.Verification, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .verification, params: params), modeling: responseModel, completion: completion)
    }
    
    func resendVerification<T:Codable>(params: UserParams.ResendVerification, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .resendVerification, params: params), modeling: responseModel, completion: completion)
    }
    
    func logout<T:Codable>(params: UserParams.logout, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .logout, params: params), modeling: responseModel, completion: completion)
    }
    func updateProfile<T:Codable>(params: UserParams.UpdateProfile, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .updateProfile, params: params), modeling: responseModel, completion: completion)
    }
    
    func createHabit<T:Codable>(params: HabitParams.CreateHabit, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .createHabit, params: params), modeling: responseModel, completion: completion)
    }
    
    func allHabitList<T:Codable>(params: HabitParams.AllHabitList, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .allHabitList, params: params), modeling: responseModel, completion: completion)
    }
    
    func updateHabit<T:Codable>(params: HabitParams.UpdateHabit, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .updateHabit, params: params), modeling: responseModel, completion: completion)
    }
    
    func deleteHabit<T:Codable>(params: HabitParams.DeleteHabit, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .deleteHabit, params: params), modeling: responseModel, completion: completion)
    }
    
    func habitDetail<T:Codable>(params: HabitParams.HabitDetail, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .habitDetail, params: params), modeling: responseModel, completion: completion)
    }
        
    func markAsComplete<T:Codable>(params: HabitParams.MarkAsComplete, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .markAsComplete, params: params), modeling: responseModel, completion: completion)
    }
    
    func shareHabit<T:Codable>(params: HabitParams.ShareHabit, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .shareHabit, params: params), modeling: responseModel, completion: completion)
    }
    
    func habitCalender<T:Codable>(params: HabitParams.HabitCalender, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .habitCalender, params: params), modeling: responseModel, completion: completion)
    }
    
    func joinHabit<T:Codable>(params: HabitParams.JoinHabit, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .joinHabit, params: params), modeling: responseModel, completion: completion)
    }
    
    func groupHabitMembers<T:Codable>(params: HabitParams.GroupHabitMembers, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .groupHabitMembers, params: params), modeling: responseModel, completion: completion)
    }
    
    func groupHabitDetails<T:Codable>(params: HabitParams.GroupHabitDetails, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .groupHabitDetails, params: params), modeling: responseModel, completion: completion)
    }
    
    func fetchCommunity<T:Codable>(params: CommunityParams.FetchCommunity, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: CommunityRequest(type: .fetchCommunity, params: params), modeling: responseModel, completion: completion)
    }
    
    func allGroupHabit<T:Codable>(params: CommunityParams.AllGroupHabit, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: CommunityRequest(type: .allGroupHabit, params: params), modeling: responseModel, completion: completion)
    }
    
    func friends<T:Codable>(params: CommunityParams.Friends, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: CommunityRequest(type: .friends, params: params), modeling: responseModel, completion: completion)
    }
    
    func friendsForShare<T:Codable>(params: HabitParams.Friends, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .friends, params: params), modeling: responseModel, completion: completion)
    }
        
    func groupHabitMembers<T:Codable>(params: CommunityParams.GroupHabitMembers, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: CommunityRequest(type: .groupHabitMembers, params: params), modeling: responseModel, completion: completion)
    }
    
    func subscription<T:Codable>(params: UserParams.Subscription, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: AuthRequests(type: .subscription, params: params), modeling: responseModel, completion: completion)
    }
    
    func getSubscription<T:Codable>(params: HabitParams.GetSubscription, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .getSubscription, params: params), modeling: responseModel, completion: completion)
    }
        
    func updateSubscription<T:Codable>(params: HabitParams.UpdateSubscription, responseModel: T.Type, completion: @escaping APIResult<T>) {
        dispatcher.execute(requst: HabitRequests(type: .updateSubscription, params: params), modeling: responseModel, completion: completion)
    }
    
}

