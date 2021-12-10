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

// MARK: - HabitDetails
struct HabitDetails: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name, colorTheme, icon: String?
    let reminders: Bool?
    let habitDescription: String?
    let groupImage: JSONNull?
    let userID: Int?
    let timer, createdAt, updatedAt: String?
    let habitMarks: [HabitMark]?

    enum CodingKeys: String, CodingKey {
        case id
        case habitType = "habit_type"
        case days, name
        case colorTheme = "color_theme"
        case icon, reminders
        case habitDescription = "description"
        case groupImage = "group_image"
        case userID = "user_id"
        case timer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case habitMarks = "habit_marks"
    }
}

// MARK: - HabitMark
struct HabitMark: Codable {
    let id, habitID: Int?
    let habitDay: String?
    let isCompleted: Bool?
    let createdAt, updatedAt: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case habitID = "habit_id"
        case habitDay = "habit_day"
        case isCompleted = "is_completed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userID = "user_id"
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

