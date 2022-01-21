//
//  AddMemojiViewModel.swift
//  Iscra
//
//  Created by mac on 12/01/22.
//

import UIKit
import Foundation
import SVProgressHUD
import Quickblox

final class AddMemojiViewModel {
    
    var username: String = ""
    weak var view: OnboardingViewRepresentable?
    var selectedImage: UIImage! = OnboadingUtils.shared.userImage // singleton class

     func updateProfile() {
        let parameters =  UserParams.UpdateProfile(username: UserStore.userName)
        print("Parameter====>\(parameters)")
        WebService().requestMultiPart(urlString: APIConstants.updateProfile,
                                      httpMethod: .put,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["profile_image": selectedImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["profile_image": selectedImage ?? UIImage()]) { [weak self](resp, err) in
            if err != nil {
               // view?.onAction(.updateProfile)
                return
            } else {
                if let response = resp as? SuccessResponseModel  {
                    if response.status == true {
                        UserStore.save(userID: response.data?.user?.id)
                        UserStore.save(userName: response.data?.user?.username)
                        UserStore.save(userImage: response.data?.user?.profileImage)
                        UserStore.save(token: response.data?.user?.authenticationToken)
                        NotificationCenter.default.post(name: .UpdateUserImage, object: nil)
                        QBChatLogin.shared.updateFullName(fullName: self?.username ?? "", customData: self?.selectedImage as? String ?? "")
                        self?.view?.onAction(.updateProfile)
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}





