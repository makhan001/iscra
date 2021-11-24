//
//  OnboardingAdaptables.swift
//  Iscra
//
//  Created by Lokesh Patil on 16/11/21.
//

import Foundation

enum OnboardingScreenType: String {
    case signup
    case login
    case forgot
    case verification
    case forgotpassword
}
enum OnboardingAction {
    case inputComplete(_ screen: OnboardingScreenType)
    case editingDidEnd(_ field:String, _ value:String)
    case editingDidChange(_ field:String, _ value:String)
    case requireFields(_ text:String)
    case validEmail(text:String)
    case errorMessage(_ text:String)
    case register
    case login(_ text:String)
    case landing
    case verification
    case resendVerification
    case forgotPassword
    case changePassword
    case socialLogin
    case terms
    case privacy
    case feedback
    case aboutUs
    case staticContent
    case aboutUsContent
    case sessionExpired
}
protocol InputFieldAlertDelegate:AnyObject {
    func userInput(_ text: String)
}
protocol InputViewDelegate:AnyObject {
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType)
}
protocol OnboardingViewRepresentable:AnyObject {
    func onAction(_ action: OnboardingAction)
}
protocol OnboardingServiceProvidable:AnyObject {
    var  delegate: OnboardingServiceProvierDelegate? { get set }
    func login(param:UserParams.Login)
    func register(param:UserParams.Signup)
    func socialLogin(param: UserParams.SocialLogin)
    func changePassword(param:UserParams.ChangePassword)
    func forgotPassword(param:UserParams.ForgotPassword)
    func verification(param:UserParams.Verification)
    func resendVerification(param:UserParams.ResendVerification)
}
protocol OnboardingServiceProvierDelegate:AnyObject {
    func completed<T>(for action:OnboardingAction, with response:T?, with error:APIError?)
}