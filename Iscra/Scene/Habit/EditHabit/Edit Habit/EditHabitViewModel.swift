//
//  EditHabitViewModel.swift
//  Iscra
//
//  Created by mac on 07/12/21.
//

import UIKit
import Foundation

final class EditHabitViewModel {
    var habitName = ""
    var days: String = ""
    var timer: String = ""
    var colorTheme: String = ""
    var reminders: Bool = false
    var groupImage: UIImage?
    var objHabitDetail: HabitDetails?
    let provider: HabitServiceProvidable
    weak var view: HabitViewRepresentable?
    var delegate: HabitServiceProvierDelegate?
    
    init(provider: HabitServiceProvidable) {
        self.provider = provider
        self.provider.delegate = self
    }
    
    private func validateHabitInput() {
        if Validation().textValidation(text: habitName, validationType: .habitName).0 {
            view?.onAction(.requireFields(Validation().textValidation(text: habitName, validationType: .habitName).1))
            return
        }
        
        if self.days == "" {
            view?.onAction(.requireFields(AppConstant.emptyDays))
        }else{
            HabitUtils.shared.days = self.days
            print("Api call")
            self.apiForUpdateHabit()
        }
    }
    
    func deleteHabit(habitId: String) {
        self.provider.deleteHabit(param: HabitParams.DeleteHabit(id: habitId))
    }
}

// MARK: Api Call
extension EditHabitViewModel {
    func apiForUpdateHabit() {
        let habitId = String(self.objHabitDetail?.id ?? 0)
        let icon = self.objHabitDetail?.icon ?? ""
        let habitType = HabitType(rawValue: (self.objHabitDetail?.habitType)!) ?? .good
        let description = self.objHabitDetail?.habitDescription ?? ""
        let parameters = HabitParams.UpdateHabit(id: habitId, days: self.days, icon: icon, name: self.habitName, timer: self.timer, reminders: self.reminders, habit_type: habitType.rawValue, color_theme: self.colorTheme, description: description)
        print("param is  \(parameters)")
        WebService().requestMultiPart(urlString: "habits/edit",
                                      httpMethod: .put,
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
                        self?.view?.onAction(.sucessMessage(response.message ?? ""))
                    } else {
                        self?.view?.onAction(.errorMessage(response.message ?? ERROR_MESSAGE))
                    }
                }
            }
        }
    }
}


extension EditHabitViewModel: HabitInputViewDelegate {
    func onAction(action: HabitAction, for screen: HabitScreenType) {
            switch action {
            case .inputComplete(screen): validateHabitInput()
            default: break
            }
    }
}

extension EditHabitViewModel: HabitServiceProvierDelegate {
    func completed<T>(for action: HabitAction, with response: T?, with error: APIError?) {
        DispatchQueue.main.async {
            WebService().StopIndicator()
            if error != nil {
                self.view?.onAction(.errorMessage(error?.responseData?.message ?? ERROR_MESSAGE))
            } else {
                if let resp = response as? SuccessResponseModel, resp.code == 200, let status = resp.status {
                    if status == true {
                        print("data is nil")
                        self.view?.onAction(.isHabitDelete(true, resp.message ?? ""))
                    }
                } else {
                    self.view?.onAction(.sucessMessage((response as? SuccessResponseModel)?.message ?? ERROR_MESSAGE))
                }
            }
        }
    }
}
