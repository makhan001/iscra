//
//  SignupViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import UIKit
import Foundation
import Quickblox

final class SignupViewModel {
    
    var email: String = ""
    var password: String = ""
    var social_id: String = ""
    var verificationCode: String = ""
    var socialLoginImageURL: URL?
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
                        UserStore.save(token: response.data?.register?.authenticationToken)
                        UserStore.save(isVerify: response.data?.register?.isVerified ?? false)
                        UserStore.save(userEmail: response.data?.register?.email)
                        UserStore.save(userName: response.data?.register?.username)
                        UserStore.save(userID: response.data?.register?.id)
                        UserStore.save(userImage: response.data?.register?.profileImage)
                        self?.verificationCode = response.data?.register?.verificationCode ?? ""
                        QBChatLogin.shared.registerQBUser()
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
        UserStore.save(userID: response.data?.user?.id)
        UserStore.save(userName: response.data?.user?.email)
        UserStore.save(userImage: response.data?.user?.profileImage)
        UserStore.save(token: response.data?.user?.authenticationToken)
        UserStore.save(userName: response.data?.user?.username?.capitalized)
        QBChatLogin.shared.registerQBUser()
        self.view?.onAction(.socialLogin(response.message ?? ""))
    }
    
    //Mark:- Social Login API
    func socialLogin(logintype:SocialLoginType){
        let parameters =  UserParams.SocialLogin(email: email, username: username, social_id: social_id, fcm_token: "fcmToken", device_udid: UIDevice.current.identifierForVendor?.uuidString ?? "", device_type: "ios", os_version: UIDevice.current.systemVersion, device_model: UIDevice.current.modelName, login_type: logintype)
        print("parameter---> \(parameters)")
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
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}

extension SignupViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
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

