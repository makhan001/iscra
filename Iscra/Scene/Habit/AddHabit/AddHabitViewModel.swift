//
//  AddHabitViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 25/10/21.
//


import UIKit
import Foundation

final class AddHabitViewModel {
    
    var habitName = ""
    var icon: String = ""
    var days: String = ""
    var timer: String = ""
    var colorTheme: String = ""
    var description: String = ""
    var reminders: Bool = false
    var habitType : HabitType = .good
    var groupImage: UIImage?
    var didNavigateToSetTheme:((_ :Bool)   ->())?
    
    weak var view: HabitViewRepresentable?
    
    private func validateHabitInput() {
//        self.habitName = "Qwerty"
//        self.description = "Qwerty"
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
      //  HabitUtils.shared.habitType = self.habitType
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
    }
    
    private func validateGroupImageSelection() {
        if HabitUtils.shared.habitType == .group {
               // if (HabitUtils.shared.groupImage == nil){
            if (self.groupImage == nil){
                view?.onAction(.requireFields(AppConstant.emptyGroupImage))
                    print("image unavailable")
                }else{
                    print("image available")
                    self.apiForCreateHabit()
            HabitUtils.shared.groupImage = self.groupImage
                }
        }else{
            view?.onAction(.createHabit)
        }
    }
}

extension AddHabitViewModel: HabitInputViewDelegate {
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
extension AddHabitViewModel {
    func apiForCreateHabit() {
        
        let obj = HabitUtils.shared
        let parameters = HabitParams.CreateHabit(days: obj.days, icon: obj.icon, name: obj.name, timer: obj.timer, reminders: obj.reminders, habit_type: obj.habitType.rawValue , color_theme: obj.colorTheme , description: obj.description)
        print("param is  \(parameters)")

        WebService().requestMultiPart(urlString: "habits/add_habit",
                                      httpMethod: .post,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["group_image": self.groupImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["group_image": self.groupImage ?? UIImage()]){ [weak self](resp, err) in
            if err != nil {
                //  self?.delegate?.completed(for: .register, with: resp, with: nil)
               // print("error is \(err)")
                return
            } else {
                if let response = resp as? SuccessResponseModel  {

                    if response.status == true {
                      //  print("response.data?.habit?.id is \(response.data?.habit?.id)")
                      //  self?.view?.onAction(.createHabit)
                        self?.view?.onAction(.sucessMessage(response.message ?? ""))
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}
