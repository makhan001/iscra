//
//  HabitModel.swift
//  Iscra
//
//  Created by mac on 01/12/21.
//

import Foundation

struct Habit: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name, colorTheme, icon: String?
    let reminders: Bool?
    let habitDescription: String?
    let userID: Int?
    let timer: String?
    let createdAt, updatedAt: Int?
    let groupImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case habitType = "habit_type"
        case days, name
        case colorTheme = "color_theme"
        case icon, reminders
        case habitDescription = "description"
        case userID = "user_id"
        case timer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case groupImage = "group_image"
    }
}
