//
//  SignupViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import Quickblox
import Foundation
import GoogleSignIn

final class SignupViewModel {
    
    var email: String = ""
    var password: String = ""
    var social_id: String = ""
    var verificationCode: String = ""
    var socialLoginImageURL: URL?
    var delegate: OnboardingServiceProvierDelegate?
    var username: String = OnboadingUtils.shared.username // singeleton class
    var selectedImage: UIImage! = OnboadingUtils.shared.userImage // singleton class
    let gidConfiguration = GIDConfiguration.init(clientID: AppConstant.googleClientID)
    
    let provider: OnboardingServiceProvidable
    weak var view: OnboardingViewRepresentable?
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
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
        
        let parameters =  UserParams.Signup(email: email, username: username, password: password, fcm_token: "fcmToken", os_version: UIDevice.current.systemVersion, device_model: UIDevice.current.modelName, device_udid: "", device_type: "ios")
        
        WebService().requestMultiPart(urlString: APIConstants.userRegister,
                                      httpMethod: .post,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": selectedImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["profile_image": selectedImage ?? UIImage()]){ [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .register, with: resp, with: nil)
                return
            } else {
                if let response = resp as? SuccessResponseModel  {
                    if response.status == true {
                        self?.registerSuccess(response)
                        self?.verificationCode = response.data?.register?.verificationCode ?? ""
                        self?.view?.onAction(.register)
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
    
    private func registerSuccess(_ response: SuccessResponseModel) {
        UserStore.save(isVerify: true)
        UserStore.save(userID: response.data?.register?.id)
        UserStore.save(userEmail: response.data?.register?.email)
        UserStore.save(userImage: response.data?.register?.profileImage)
        UserStore.save(token: response.data?.register?.authenticationToken)
        UserStore.save(userName: response.data?.register?.username?.capitalized)
        QBChatLogin.shared.registerQBUser()
    }
    
    func socialLogin(logintype:SocialLoginType) {
        let parameters =  UserParams.SocialLogin(email: email, username: username, social_id: social_id, fcm_token: "fcmToken", device_udid: UIDevice.current.identifierForVendor?.uuidString ?? "", device_type: "ios", os_version: UIDevice.current.systemVersion, device_model: UIDevice.current.modelName, login_type: logintype)
        if let url = socialLoginImageURL {
            if let data = try? Data(contentsOf: url) {
                self.selectedImage = UIImage(data: data) ?? UIImage()
            }
        }
        
        WebService().requestMultiPart(urlString: APIConstants.socialLogin,
                                      httpMethod: .post,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": selectedImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["profile_image": selectedImage ?? UIImage()]){ [weak self](resp, err) in
            if err != nil {
                self?.view?.onAction(.errorMessage(err ?? ERROR_MESSAGE))
                return
            } else {
                if let response = resp as? SuccessResponseModel {
                    if response.status == true {
                        self?.registerSuccess(response)
                        self?.view?.onAction(.socialLogin(response.message ?? ""))
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}
