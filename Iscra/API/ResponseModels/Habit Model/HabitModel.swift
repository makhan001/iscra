//
//  HabitModel.swift
//  Iscra
//
//  Created by mac on 01/12/21.
//

import Foundation

// MARK: - Habit
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

// MARK: - GroupHabitDetails
struct GroupHabitDetails: Codable {
    let id: Int?
    let name, groupHabitDetailsDescription: String?
    let image: String?
    let memberCount: Int?
    let usersProfileImageURL: [UsersProfileImageURL]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case groupHabitDetailsDescription = "description"
        case image
        case memberCount = "member_count"
        case usersProfileImageURL = "users_profile_image_url"
    }
}

// MARK: - UsersProfileImageURL
struct UsersProfileImageURL: Codable {
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// MARK: - GroupHabitMember
struct GroupHabitMember: Codable {
    let id: Int?
    let username: String?
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id, username
        case profileImage = "profile_image"
    }
}
