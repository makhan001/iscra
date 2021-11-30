//
//  HabitNameViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 25/10/21.
//


import UIKit
import Foundation

final class HabitNameViewModel {
    
    var habitName = ""
    var icon: String = ""
    var days: String = ""
    var timer: String = ""
    var colorTheme: String = ""
    var description: String = ""
    var reminders: Bool = false
    var habitType : HabitType = .good
    var groupImage: UIImage = UIImage()
    var didNavigateToSetTheme:((_ :Bool)   ->())?
    
    weak var view: HabitViewRepresentable?
    
    private func validateHabitInput() {
        self.habitName = "Qwerty"
        self.description = "Qwerty"
        if habitType == .group{
            if Validation().textValidation(text: habitName, validationType: .habitName).0 {
                view?.onAction(.requireFields(Validation().textValidation(text: habitName, validationType: .habitName).1))
                return
            }
            
            if Validation().textValidation(text: description, validationType: .description).0 {
                view?.onAction(.requireFields(Validation().textValidation(text: description, validationType: .description).1))
                return
            }
        }else{
            if Validation().textValidation(text: habitName, validationType: .habitName).0 {
                view?.onAction(.requireFields(Validation().textValidation(text: habitName, validationType: .habitName).1))
                return
            }
        }
        HabitUtils.shared.name = self.habitName
        HabitUtils.shared.habitType = self.habitType
        HabitUtils.shared.description = self.description
        self.didNavigateToSetTheme?(true)
    }
    
    private func validateSetTheme() {
        HabitUtils.shared.icon = self.icon
        HabitUtils.shared.colorTheme = self.colorTheme
        self.didNavigateToSetTheme?(true)
    }
    
    private func validateDaysSelection() {
        if HabitUtils.shared.habitType != .group {
        if self.days == "" {
            view?.onAction(.requireFields(AppConstant.emptyDays))
        }else{
            HabitUtils.shared.days = self.days
               print("Api call")
                self.apiForCreateHabit()
        }
        }else{
            if self.days == "" {
                view?.onAction(.requireFields(AppConstant.emptyDays))
            }else{
                HabitUtils.shared.days = self.days
                view?.onAction(.navigateToGroupImage(true))
                print("navigateToGroupImage")
            }
        }
        
        
//        if HabitUtils.shared.habitType == .group {
//            //  view?.onAction(.requireFields(AppConstant.emptyGroupImage))
//        }else{
//            view?.onAction(.navigateToGroupImage(true))
//        }
        
    }
    
    private func validateGroupImageSelection() {
        if HabitUtils.shared.habitType == .group {
            if (groupImage.size.width == 0){
                view?.onAction(.requireFields(AppConstant.emptyGroupImage))
            }
            HabitUtils.shared.groupImage = self.groupImage
        }else{
            view?.onAction(.createHabit)
        }
    }
}

extension HabitNameViewModel: HabitInputViewDelegate {
    func onAction(action: HabitAction, for screen: HabitScreenType) {
        if HabitUtils.shared.habitType == .group {
            switch action {
            case .inputComplete(screen): validateHabitInput()
            case .setTheme(screen): validateSetTheme()
            case .setDaySelection(screen): validateDaysSelection()
            case .setGroupImage(screen): validateGroupImageSelection()
            default: break
            }
        }else{
            switch action {
            case .inputComplete(screen): validateHabitInput()
            case .setTheme(screen): validateSetTheme()
            case .setDaySelection(screen): validateDaysSelection()
            default: break
            }
        }
    }
}

// MARK: Api Call
extension HabitNameViewModel {
    
    func apiForCreateHabit() {
        
//        let parameters =  UserParams.Signup(email: email, username: username, password: password, fcm_token: "fcmToken", os_version: UIDevice.current.systemVersion, device_model: UIDevice.current.modelName, device_udid: "", device_type: "ios")
        let obj = HabitUtils.shared
        
        let parameters = HabitParams.CreateHabit(days: obj.days, icon: obj.icon, name: obj.name, timer: obj.timer, reminders: obj.reminders, habit_type: "good", color_theme: obj.colorTheme , description: obj.description)
        print("param is  \(parameters)")
        
        WebService().requestMultiPart(urlString: "habits",
                                      httpMethod: .post,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["group_image": obj.groupImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["group_image": obj.groupImage ?? UIImage()]){ [weak self](resp, err) in
            if err != nil {
                
              //  self?.delegate?.completed(for: .register, with: resp, with: nil)
                print("error is \(err)")
                return
            } else {
                if let response = resp as? SuccessResponseModel  {
//                    if response.status == true {
//                        UserStore.save(token: response.data?.register?.authenticationToken)
//                        UserStore.save(isVerify: response.data?.register?.isVerified ?? false)
//                        UserStore.save(userEmail: response.data?.register?.email)
//                        UserStore.save(userName: response.data?.register?.username)
//                        UserStore.save(userID: response.data?.register?.id)
//                        UserStore.save(userImage: response.data?.register?.profileImage)
//                        self?.verificationCode = response.data?.register?.verificationCode ?? ""
//                        self?.view?.onAction(.register)
//                    } else {
//                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
//                    }
                }
            }
    }
    
}
}
