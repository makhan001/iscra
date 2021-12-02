//
//  FetchHabit.swift
//  Iscra
//
//  Created by mac on 02/12/21.
//

import Foundation

// MARK: - DataClass
struct AllHabits: Codable {
    let id,userID: Int?
    let habitType: String?
    let days: [String]?
    let name, colorTheme, icon: String?
    let reminders: Bool?
    let habitDescription: String?
   // let groupImage: JSONNull?
  //  let timer: JSONNull?
    let groupImage,timer: String?
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
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
