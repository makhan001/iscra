//
//  FetchCommunity.swift
//  Iscra
//
//  Created by mac on 20/12/21.
//

import Foundation

// MARK: - GroupHabit
struct GroupHabit: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name, colorTheme, icon: String?
    let reminders: Bool?
    let groupHabitDescription: String?
    let userID: Int?
    let timer: String?
    let createdAt, updatedAt: Int?
    let habitMarks: [HabitMark]?
    let inviteHabits: InviteHabits?

    enum CodingKeys: String, CodingKey {
        case id
        case habitType = "habit_type"
        case days, name
        case colorTheme = "color_theme"
        case icon, reminders
        case groupHabitDescription = "description"
        case userID = "user_id"
        case timer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case habitMarks = "habit_marks"
        case inviteHabits = "invite_habits"
    }
}

// MARK: - HabitMark
//struct HabitMark: Codable {
//    let id, habitID, habitDay: Int?
//    let isCompleted: Bool?
//    let createdAt, updatedAt, userID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case habitID = "habit_id"
//        case habitDay = "habit_day"
//        case isCompleted = "is_completed"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case userID = "user_id"
//    }
//}

// MARK: - InviteHabits
struct InviteHabits: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name, colorTheme, icon: String?
    let reminders: Bool?
    let inviteHabitsDescription: String?
    let userID: Int?
    let timer, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case habitType = "habit_type"
        case days, name
        case colorTheme = "color_theme"
        case icon, reminders
        case inviteHabitsDescription = "description"
        case userID = "user_id"
        case timer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
