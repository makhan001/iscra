//
//  UpdateProfileViewModel.swift
//  Iscra
//
//  Created by Dr.Mac on 27/11/21.
//

import UIKit
import Quickblox
import Foundation

final class UpdateProfileViewModel {
    
    var username: String = ""
    var isSubscribed: Bool = false
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
        guard let name = UserStore.userName else { return }
        if name.trim().lowercased() == username.trim().lowercased() {
            self.view?.onAction(.errorMessage("Please update username"))
            return
        }
        self.updateUser()
    }
    
    func updateUser() {
        let parameters =  UserParams.UpdateProfile(username: username, isSubscribed: isSubscribed)
        WebService().requestMultiPart(urlString: APIConstants.updateProfile,
                                      httpMethod: .put,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": self.selectedImage]],
                                      fileArray: [],
                                      file: ["profile_image": self.selectedImage]){ [weak self](resp, err) in
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
                        QBChatLogin.shared.updateFullName(fullName: self?.username ?? "", customData: "")
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
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(ERROR_MESSAGE))
            } else {
                QBChatLogin.shared.updateFullName(fullName: self.username, customData: self.selectedImage as? String ?? "")
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

