//
//  AuthRequests.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 14/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation

struct AuthRequests: RequestRepresentable {
    
    var signup: UserParams.Signup?
    var login: UserParams.Login?
    var changePassword: UserParams.ChangePassword?
    var forgotPassword: UserParams.ForgotPassword?
    var socialLogin: UserParams.SocialLogin?
    var verification: UserParams.Verification?
    var resendVerification: UserParams.ResendVerification?
    var updateProfile: UserParams.UpdateProfile?
    var subscription: UserParams.Subscription?
    
    let requestType: RequestType
    enum RequestType {
        case signup
        case login
        case changePassword
        case forgotPassword
        case terms
        case privacy
        case socialLogin
        case logout
        case verification
        case resendVerification
        case updateProfile
        case subscription
    }
    
    init(requestType: RequestType) {
        self.requestType = requestType
    }
    
    init(type: RequestType, params:Codable) {
        self.requestType = type
        switch params {
        case is UserParams.Signup:
            self.signup = params as? UserParams.Signup
        case is UserParams.Login:
            self.login = params as? UserParams.Login
        case is UserParams.ChangePassword:
            self.changePassword = params as? UserParams.ChangePassword
        case is UserParams.ForgotPassword:
            self.forgotPassword = params as? UserParams.ForgotPassword
        case is UserParams.SocialLogin:
            self.socialLogin = params as? UserParams.SocialLogin
        case is UserParams.Verification:
            self.verification = params as? UserParams.Verification
        case is UserParams.ResendVerification:
            self.resendVerification = params as? UserParams.ResendVerification
        case is UserParams.UpdateProfile:
            self.updateProfile = params as? UserParams.UpdateProfile
        case is UserParams.Subscription:
            self.subscription = params as? UserParams.Subscription
        default:break
        }
    }
    
    var method: HTTPSMethod {
        switch self.requestType {
        case .terms, .privacy:
            return .get
        case .logout:
            return .delete
        case .updateProfile:
            return .put
        default:
            return .post
        }
    }
    
    var endpoint: String {
        switch self.requestType {
        case .signup:
            return "users/registration"
        case .login:
            return "users/login"
        case .changePassword:
            return "users/changepassword"
        case .forgotPassword:
            return "users/forgotpassword"
        case .terms:
            return "static_page/terms_condition"
        case .privacy:
            return "static_page/privacy_policy"
        case .socialLogin:
            return "users/social_login"
        case .logout:
            return "users/logout"
        case .verification:
            return "users/verification"
        case .resendVerification:
            return "users/resendverification"
        case .updateProfile:
            return "users/update"
        case .subscription:
            return "subscribe/subscription"
        }
    }

    var parameters: Parameters {
        switch self.requestType {
        case .signup:
            return .body(data: encodeBody(data: signup))
        case .login:
            return .body(data: encodeBody(data: login))
        case .changePassword:
            return .body(data: encodeBody(data: changePassword))
        case .forgotPassword:
            return .body(data: encodeBody(data: forgotPassword))
        case .socialLogin:
            return .body(data: encodeBody(data: socialLogin))
        case .verification:
            return .body(data: encodeBody(data: verification))
        case .resendVerification:
            return .body(data: encodeBody(data: resendVerification))
        case .subscription:
            return .body(data: encodeBody(data: subscription))
        default:
            return .none
        }
    }
}
