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
    var description: String = ""
    var habitType : habitType = .good
    var didNavigateToSetTheme:((_ :Bool)   ->())?

    weak var view: HabitViewRepresentable?

    private func validateUserInput() {
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
        HabitUtils.shared.name = habitName
        HabitUtils.shared.description = description
        self.didNavigateToSetTheme?(true)
    }
}

extension AddHabitViewModel: HabitInputViewDelegate {
    func onAction(action: HabitAction, for screen: HabitScreenType) {
        switch action {
        case .inputComplete(screen): validateUserInput()
        default: break
        }
    }
}
