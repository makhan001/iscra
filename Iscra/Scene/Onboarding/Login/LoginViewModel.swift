//
//  SignupViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 18/11/21.
//

import UIKit
import Quickblox
import Foundation
import GoogleSignIn

final class LoginViewModel {
    
    var email: String = "deepraj@gmail.com"
    var password: String = "123456"
    var username: String = ""
    var social_id: String = ""
    var socialLoginImageURL: URL?
    var selectedImage: UIImage = UIImage()
    var delegate: OnboardingServiceProvierDelegate?
    let gidConfiguration = GIDConfiguration.init(clientID: AppConstant.googleClientID)
    
    weak var view: OnboardingViewRepresentable?
    let provider: OnboardingServiceProvidable
    
    init(provider: OnboardingServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    func onAction(action: OnboardingAction, for screen: OnboardingScreenType) {
        switch action {
        case .inputComplete(screen): validateUserInput()
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
        self.provider.login(param: UserParams.Login(email: email, password: password, fcm_token: "fcmToken", os_version: UIDevice.current.systemVersion, device_model: UIDevice.current.modelName, device_udid: "" , device_type: "ios"))
    }
    
    private func loginSuccess(_ response: SuccessResponseModel) {
        UserStore.save(isVerify: true)
        UserStore.save(userID: response.data?.user?.id)
        UserStore.save(userEmail: response.data?.user?.email)
        UserStore.save(userImage: response.data?.user?.profileImage)
        UserStore.save(token: response.data?.user?.authenticationToken)
        UserStore.save(userName: response.data?.user?.username?.capitalized)
        UserStore.save(userCreateDate: (response.data?.user?.createdAt ?? 0).toDouble)
        UserStore.save(primeUser: response.data?.user?.isSubscribed)
        QBChatLogin.shared.loginQBUser(fullName: self.username, login: self.email, email: self.email, customData: "")
        
        if UserStore.userCreateDate.daysDifference <= 21 {
            self.view?.onAction(.socialLogin(response.message ?? ""))
        } else if UserStore.primeUser == true {
            self.view?.onAction(.socialLogin(response.message ?? ""))
        }  else {
            self.view?.onAction(.subscription)
        }
    }
    
    func socialLogin(logintype:SocialLoginType) {
        let parameters =  UserParams.SocialLogin(email: email, username: username, social_id: social_id, fcm_token: "fcmToken", device_udid: UIDevice.current.identifierForVendor?.uuidString ?? "", device_type: "ios", os_version: UIDevice.current.systemVersion, device_model: UIDevice.current.modelName, login_type: SocialLoginType(rawValue: logintype.rawValue))
        
        if let url = socialLoginImageURL {
            if let data = try? Data(contentsOf: url) {
                self.selectedImage = UIImage(data: data) ?? UIImage()
            }
        }
        
        WebService().requestMultiPart(urlString: APIConstants.socialLogin,
                                      httpMethod: .post,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": selectedImage]],
                                      fileArray: [],
                                      file: ["profile_image": selectedImage ]) { [weak self](resp, err) in
            if err != nil {
                self?.view?.onAction(.errorMessage(err ?? ERROR_MESSAGE))
                return
            } else {
                if let response = resp as? SuccessResponseModel {
                    if response.status == true {
                        self?.loginSuccess(response)
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}

extension LoginViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200 {
                    UserStore.save(token: resp.data?.loginData?.authenticationToken)
                    UserStore.save(isVerify: resp.data?.loginData?.isVerified ?? false)
                    UserStore.save(userEmail: resp.data?.loginData?.email)
                    UserStore.save(userName: resp.data?.loginData?.username)
                    UserStore.save(userID: resp.data?.loginData?.id)
                    UserStore.save(userImage: resp.data?.loginData?.profileImage)
                    UserStore.save(userCreateDate: (resp.data?.loginData?.createdAt ?? 0).toDouble)
                    UserStore.save(primeUser: resp.data?.loginData?.isSubscribed)
                    QBChatLogin.shared.loginQBUser(fullName: self.username, login: self.email, email: self.email, customData: "")
                    if resp.data?.loginData?.isVerified == true {
                        //  self.view?.onAction(.login(resp.message ?? "", resp.data?.loginData?.isVerified ?? false))
                        if UserStore.userCreateDate.daysDifference <= 21 {
                            self.view?.onAction(.login(resp.message ?? "", true))
                        } else if UserStore.primeUser == true {
                            self.view?.onAction(.login(resp.message ?? "", true))
                        } else {
                            self.view?.onAction(.subscription)
                        }
                    } else {
                        self.view?.onAction(.login("", resp.data?.loginData?.isVerified ?? false))
                    }
                    
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
