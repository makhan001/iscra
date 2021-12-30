//
//  AddHabitViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 25/10/21.
//


import UIKit
import Foundation

final class AddHabitViewModel {
    
    var habitId: Int = 0
    var habitName = ""
    var icon: String = ""
    var days: String = ""
    var timer: String = ""
    var colorTheme: String = ""
    var description: String = ""
    var reminderTime: String = ""
    var reminders: Bool = false
    var habitType : HabitType = .good
    var groupImage: UIImage?
    var didNavigateToSetTheme:((_ :Bool)   ->())?
    
    var selectedColorTheme =  HabitThemeColor(id: "1", colorHex: "#ff7B86EB", isSelected: true)
    var weakDays = WeakDaysArray
    weak var view: HabitViewRepresentable?
    
    private func validateHabitInput() {
        
        self.habitName  = self.habitName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.description  = self.description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if habitType == .group {
            if Validation().textValidation(text: habitName, validationType: .habitName).0 {
                view?.onAction(.requireFields(Validation().textValidation(text: habitName, validationType: .habitName).1))
                return
            }
            
            if Validation().textValidation(text: description, validationType: .description).0 {
                view?.onAction(.requireFields(Validation().textValidation(text: description, validationType: .description).1))
                return
            }
        } else {
            if Validation().textValidation(text: habitName, validationType: .habitName).0 {
                view?.onAction(.requireFields(Validation().textValidation(text: habitName, validationType: .habitName).1))
                return
            }
        }
        HabitUtils.shared.name = self.habitName
        HabitUtils.shared.description = self.description
        self.didNavigateToSetTheme?(true)
    }
    
    private func validateSetTheme() {
        HabitUtils.shared.icon = self.icon
        HabitUtils.shared.colorTheme = self.colorTheme
        self.didNavigateToSetTheme?(true)
    }
    
    private func setDaysAfterSelection() {
        self.days = (weakDays.filter { $0.isSelected }.map{ $0.dayname}.sorted(by: { (WeekDayNumbers[$0] ?? 7) < (WeekDayNumbers[$1] ?? 7) })).joined(separator: ",")
        HabitUtils.shared.days = self.days
    }
    
    private func validateDaysSelection() {
        if HabitUtils.shared.habitType != .group {
            if weakDays.filter({ $0.isSelected }).isEmpty {
                view?.onAction(.requireFields(AppConstant.emptyDays))
            } else {
                self.setDaysAfterSelection()
                self.addHabit()
            }
        } else {
            if weakDays.filter({ $0.isSelected }).isEmpty {
                view?.onAction(.requireFields(AppConstant.emptyDays))
            } else {
                self.setDaysAfterSelection()
                self.view?.onAction(.navigateToGroupImage(true))
            }
        }
    }
    
    private func validateGroupImageSelection() {
        if HabitUtils.shared.habitType == .group {
            // if (HabitUtils.shared.groupImage == nil){
            if (self.groupImage == nil){
                view?.onAction(.requireFields(AppConstant.emptyGroupImage))
                print("image unavailable")
            } else {
                print("image available")
                self.addHabit()
                HabitUtils.shared.groupImage = self.groupImage
            }
        } else {
            view?.onAction(.createHabit)
        }
    }
    
    func sortWeekDays(days: String) {
        self.days = (days.components(separatedBy: ",").sorted(by: { (WeekDayNumbers[$0] ?? 7) < (WeekDayNumbers[$1] ?? 7) })).joined(separator: ",")
        print(self.days)
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
        } else {
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
    func addHabit() {
        let obj = HabitUtils.shared
        let parameters = HabitParams.CreateHabit(days: obj.days, icon: obj.icon, name: obj.name, timer: obj.timer, reminders: obj.reminders, habit_type: obj.habitType.rawValue , color_theme: obj.colorTheme , description: obj.description)
        
        WebService().requestMultiPart(urlString: APIConstants.addHabit,
                                      httpMethod: .post,
                                      parameters: parameters,
                                      decodingType: SuccessResponseModel.self,
                                      imageArray: [["group_image": self.groupImage ?? UIImage()]],
                                      fileArray: [],
                                      file: ["group_image": self.groupImage ?? UIImage()]){ [weak self](resp, err) in
            if err != nil {
                return
            } else {
                if let response = resp as? SuccessResponseModel  {
                    if response.status == true {
                        if let objHabit = response.data?.habit {
                            self?.habitId = objHabit.id ?? 0
                        }
                        self?.view?.onAction(.sucessMessage(response.message ?? ""))
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}
