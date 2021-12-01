//
//  HabitUtils.swift
//  Iscra
//
//  Created by mac on 29/11/21.
//

import UIKit
import Foundation

class HabitUtils {

    // MARK: - Properties
    static let shared = HabitUtils()
    
    // MARK: -
    var name: String = "" ///
    var colorTheme: String = "" /// "#7B86EB"
    var description: String = "" ///
    var icon: String = "" /// "sport1"
    var days: String = ""
    var timer: String = "" ///
    var reminders: Bool = false ///
    var groupImage: UIImage?
    var habitType: HabitType = .good ///
}
