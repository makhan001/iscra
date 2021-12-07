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


//import Foundation
//
//enum HabitUnion {
//    case fluffyHabit(FluffyHabit)
//    case purpleHabitArray([PurpleHabit])
//}
//
//// MARK: - PurpleHabit
//struct PurpleHabit {
//    let id, habitID: Int?
//    let habitDay, createdAt, updatedAt: String?
//    let isCompleted: Bool?
//}
//
//// MARK: - FluffyHabit
//struct FluffyHabit {
//    let id: Int?
//    let habitType: String?
//    let days: [String]?
//    let name, colorTheme, icon: String?
//    let reminders: Bool?
//    let habitDescription: String?
//    let groupImage: String?
//    let userID: Int?
//    let timer, createdAt, updatedAt: String?
//}

