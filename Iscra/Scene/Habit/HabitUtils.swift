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
    var name: String = ""
    var color_theme: String = ""
    var description: String = ""
    var icon: String = ""
    var days: String = ""
    var timer: String = ""
    var reminders: Bool = false
    var group_image: UIImage = UIImage()
    var habitType : habitType = .good
}
