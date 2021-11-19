//
//  SignupViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 18/11/21.
//

import UIKit
import Foundation

final class LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    
    weak var view: OnboardingViewRepresentable?
    let provider: OnboardingServiceProvidable
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType) {
        switch action {
        case .login: validateUserInput()
        default: break
        }
    }
    
    private func validateUserInput() {
//        self.provider.login(param: UserParams.Login(email: email, password: password, fcm_token:  UserStore.fcmtoken, device_id: nil, device_type: "ios"))
        self.provider.login(param: UserParams.Login(email: email, password: password))

//        WebService().requestMultiPart(urlString: "users/login", httpMethod: .post, parameters: UserParams.Login(email: email, password: password), decodingType: SuccessResponseModel.self, imageArray: [], fileArray: []) { (resp, str) in
//            print("resp ---> \(resp)")
//            print("str ---> \(str)")
//        }
        
//        if Validation().textValidation(text: email, validationType: .email).0 {
//            view?.onAction(.requireFields(Validation().textValidation(text: email, validationType: .email).1))
//            return
//        }
//
//        if Validation().textValidation(text: password, validationType: .password).0 {
//            view?.onAction(.requireFields(Validation().textValidation(text: password, validationType: .password).1))
//            return
//        }
       // self.provider.register(param: UserParams.Signup(email: email, username: username, password: password, fcm_token: UserStore.fcmtoken, device_id: nil, device_type: "ios"))
       // self.provider.login(param: UserParams.Login(email: email, password: password, fcm_token:  UserStore.fcmtoken, device_id: nil, device_type: "ios"))

    }
}

extension LoginViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                //                guard let message = error?.responseData?.message else {
                //                    self.view?.onAction(.errorMessage(ERROR_MESSAGE))
                //                    return
                //                }
                self.view?.onAction(.errorMessage(ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.status == true {
                    //                   self.register = resp.data?.register
                    self.view?.onAction(.login)
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}













