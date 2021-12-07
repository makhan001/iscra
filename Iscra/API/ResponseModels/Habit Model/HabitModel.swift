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
    let habitDescription, groupImage: String?
    let userID: Int?
    let timer: String?
  //  let timer: JSONNull?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case habitType = "habit_type"
        case days, name, timer
        case colorTheme = "color_theme"
        case icon, reminders
        case habitDescription = "description"
        case groupImage = "group_image"
        case userID = "user_id"
      //  case timer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
