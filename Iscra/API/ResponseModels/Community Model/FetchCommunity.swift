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

// MARK: - InviteHabits
struct InviteHabits: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name, colorTheme, icon: String?
    let reminders: Bool?
    let inviteHabitsDescription: String?
    let userID: Int?
   // let timer, createdAt, updatedAt: String?
    let timer: String?
    let createdAt, updatedAt: Int?

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

// MARK: - Invitaion
struct Invitaion: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name, colorTheme, icon: String?
    let reminders: Bool?
    let invitaionDescription: String?
    let userID: Int?
   // let timer, createdAt, updatedAt: String?
    let timer: String?
    let createdAt, updatedAt: Int?
    let groupImage: String?
    enum CodingKeys: String, CodingKey {
        case id
        case habitType = "habit_type"
        case days, name
        case colorTheme = "color_theme"
        case icon, reminders
        case invitaionDescription = "description"
        case userID = "user_id"
        case timer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case groupImage = "group_image"
    }
}

// MARK: - Friend
struct Friend: Codable {
    let id: Int?
    let email: String?
    let verificationCode: String?
    let authenticationToken, username: String?
    let memoji: String?
    let isVerified: Bool?
    let deviceType, osVersion, deviceModel, fcmToken: String?
    let forgotPassword, deviceUdid: String?
    let loginType: String?
    let socialID: String?
    let isGoogle, isApple: Bool?
    let createdAt, updatedAt: Int?

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case verificationCode = "verification_code"
        case authenticationToken = "authentication_token"
        case username, memoji
        case isVerified = "is_verified"
        case deviceType = "device_type"
        case osVersion = "os_version"
        case deviceModel = "device_model"
        case fcmToken = "fcm_token"
        case forgotPassword = "forgot_password"
        case deviceUdid = "device_udid"
        case loginType = "login_type"
        case socialID = "social_id"
        case isGoogle = "is_google"
        case isApple = "is_apple"
    }
}

////////////////////////////////

// MARK: - AllGroupHabit
struct AllGroupHabit: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name: String?
    let colorTheme: String?
    let icon: String?
    let reminders: Bool?
    let allGroupHabitDescription: String?
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
        case allGroupHabitDescription = "description"
        case userID = "user_id"
        case timer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case groupImage = "group_image"
    }
}
