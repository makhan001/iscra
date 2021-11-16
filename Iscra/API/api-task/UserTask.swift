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
//
//    func aboutUs(completion:@escaping APIResult<SuccessResponseModel> ) {
//        dispatcher.execute(requst: AuthRequests(requestType: .aboutus), modeling: SuccessResponseModel.self, completion:   completion)
//    }
//
//    func aboutUsContent(completion:@escaping APIResult<SuccessResponseModel> ) {
//        dispatcher.execute(requst: AuthRequests(requestType: .aboutUsContent), modeling: SuccessResponseModel.self, completion:   completion)
//    }
//
//    func termsAndConditions(completion:@escaping APIResult<SuccessResponseModel> ) {
//        dispatcher.execute(requst: AuthRequests(requestType: .terms), modeling: SuccessResponseModel.self, completion:   completion)
//    }
//
//    func privacy(completion:@escaping APIResult<SuccessResponseModel> ) {
//        dispatcher.execute(requst: AuthRequests(requestType: .privacy), modeling: SuccessResponseModel.self, completion:   completion)
//    }
//
//    func myProfile(completion:@escaping APIResult<SuccessResponseModel> ) {
//        dispatcher.execute(requst: UserRequests(requestType: .profile), modeling: SuccessResponseModel.self, completion:   completion)
//    }
//
//    func logout(completion:@escaping APIResult<SuccessResponseModel> ) {
//        dispatcher.execute(requst: AuthRequests(requestType: .logout), modeling: SuccessResponseModel.self, completion:   completion)
//    }
}
