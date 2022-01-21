//
//  File.swift
//  Iscra
//
//  Created by Lokesh Patil on 09/11/21.
//

import Foundation

// MARK: - IconsHabitModel
struct IconsHabitModel: Codable {
    var iconCategory: [IconCategory]
}

// MARK: - IconCategory
struct IconCategory: Codable {
    var habitName, habitId: String
    var icons: [IconModel]
    var isSelected: Bool
}

// MARK: - Icon
struct IconModel: Codable {
    var iconId, iconName: String
    var isSelected: Bool
}
