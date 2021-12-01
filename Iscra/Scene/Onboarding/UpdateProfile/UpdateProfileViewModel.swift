//
//  UpdateProfileViewModel.swift
//  Iscra
//
//  Created by Dr.Mac on 27/11/21.
//

import UIKit
import Foundation

final class UpdateProfileViewModel {
    

    var username: String = ""
    var selectedImage: UIImage = UIImage()
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
        
        if Validation().textValidation(text: username, validationType: .name).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: username, validationType: .name).1))
            return
        }
        let parameters =  UserParams.UpdateProfile(username: username)
        WebService().requestMultiPart(urlString: "/users/update",
                                      httpMethod: .put,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": selectedImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["profile_image": selectedImage ?? UIImage()]){ [weak self](resp, err) in
            if err != nil {
                
                self?.delegate?.completed(for: .updateProfile, with: resp, with: nil)
                return
            } else {
                if let response = resp as? SuccessResponseModel  {
                    if response.status == true {
                        UserStore.save(token: response.data?.user?.authenticationToken)
                        UserStore.save(userName: response.data?.user?.username?.capitalized)
                        print("updateProfileApi Success---> \(response)")
                        UserStore.save(userID: response.data?.user?.id)
                        UserStore.save(userImage: response.data?.user?.profileImage)
                      
                        self?.view?.onAction(.updateProfile)
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}

extension UpdateProfileViewModel: OnboardingServiceProvierDelegate, InputViewDelegate {
    func completed<T>(for action: OnboardingAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            if error != nil {
                self.view?.onAction(.errorMessage(ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.status == true {
                                   //    self.register = resp.data?.register
                    UserStore.save(token: resp.data?.register?.authenticationToken)
                    
                    self.view?.onAction(.updateProfile)
                } else {
                    self.view?.onAction(.errorMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}

