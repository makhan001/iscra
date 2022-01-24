//
//  OnboardingAdaptables.swift
//  Iscra
//
//  Created by Lokesh Patil on 16/11/21.
//

import Foundation

enum SubscriptionSourceScreen: String {
    case login
    case myAccount
}

enum MemojiSourceScreen: String {
    case walkthrough
    case myAccount
}

enum OnboardingScreenType: String {
    case signup
    case login
    case verification
    case forgotPassword
    case changePassword
   case updateProfile
    case socialLogin
}
enum OnboardingAction {
    case inputComplete(_ screen: OnboardingScreenType)
    case editingDidEnd(_ field:String, _ value:String)
    case editingDidChange(_ field:String, _ value:String)
    case requireFields(_ text:String)
    case validEmail(text:String)
    case errorMessage(_ text:String)
    case register
    case login(_ text:String, _ is_varified:Bool)
    case landing
    case verification(_ text:String)
    case resendVerification
    case forgotPassword(_ text:String )
    case changePassword(_ text:String)
    case socialLogin(_ text:String)
    case terms
    case privacy
    case feedback
    case staticContent
    case sessionExpired
    case logout
    case updateProfile
    case subscription
    case products
}
protocol InputFieldAlertDelegate:AnyObject {
    func userInput(_ text: String)
}
protocol InputViewDelegate:AnyObject {
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType)
}
protocol VerificationViewControllerDelegate:AnyObject {
    func isUserVerified()
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
    func logout(param:UserParams.logout)
    func updateProfile(param:UserParams.UpdateProfile)
    func subscription(param:UserParams.Subscription)
}
protocol OnboardingServiceProvierDelegate:AnyObject {
    func completed<T>(for action:OnboardingAction, with response:T?, with error:APIError?)
}
