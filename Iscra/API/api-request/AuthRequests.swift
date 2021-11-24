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
    var logout: UserParams.logout?

    let requestType: RequestType
    enum RequestType {
        case signup
        case login
        case changePassword
        case forgotPassword
        case terms
        case privacy
        case socialLogin
        case aboutus
        case aboutUsContent
        case logout
        case verification
        case resendVerification
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
        default:break
        }
    }
    
    var method: HTTPMethod {
        switch self.requestType {
        case .terms, .privacy, .aboutus, .aboutUsContent:
            return .get
        case .logout:
            return .delete
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
        case .aboutUsContent:
            return "saloon/about"
        case .aboutus:
            return "saloon/about"
        case .logout:
            return "users/logout"
        case .verification:
           return "users/verification"
        case .resendVerification:
           return "users/resendverification"
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
        case .logout:
            return .body(data: encodeBody(data: logout))
        default:
            return .none
        }
    }
}
