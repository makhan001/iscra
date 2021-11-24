//
//  SignupViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import Foundation

final class SignupViewModel {
    
    var email: String = ""
    var password: String = ""
    var username: String = OnboadingUtils.shared.username // singeleton class
    var selectedImage: UIImage! = OnboadingUtils.shared.userImage // singleton class
    var delegate: OnboardingServiceProvierDelegate?

    weak var view: OnboardingViewRepresentable?
    let provider: OnboardingServiceProvidable
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
        delegate = self
    }
    
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType) {
        switch action {
        case .inputComplete: validateUserInput()
        default: break
        }
    }
    
    private func validateUserInput() {
        
        if Validation().textValidation(text: email, validationType: .email).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: email, validationType: .email).1))
            return
        }
        
        if Validation().textValidation(text: password, validationType: .password).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: password, validationType: .password).1))
            return
        }
        WebService().requestMultiPart(urlString: "/users/registration",
                                      httpMethod: .post,
                                      parameters: UserParams.Signup(email: email, username: username, password: password, fcm_token: "fcmToken", os_version: UIDevice.current.systemVersion, device_model: UIDevice.current.modelName, device_udid: "", device_type: "ios"),
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": selectedImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["profile_image": selectedImage ?? UIImage()]){ [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .register, with: resp, with: nil)
                return
            } else {
                if let response = resp as? SuccessResponseModel  {
                    (response.status == true) ? self?.view?.onAction(.register) : self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}

extension SignupViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
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
                    UserStore.save(token: resp.data?.register?.authenticationToken)
                    self.view?.onAction(.register)
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}

