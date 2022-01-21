//
//  FetchHabit.swift
//  Iscra
//
//  Created by mac on 02/12/21.
//

import Foundation

// MARK: - Habit
struct AllHabits: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name: String?
    let colorTheme: String?
    let icon: String?
    let reminders: Bool?
    let habitDescription: String?
    let userID: Int?
    let timer: String?
    let createdAt, updatedAt: Int?
    let groupImage: String?
    let habitMarks: [HabitMark]?
    let groupMembers: [GroupMember]?

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
        case habitMarks = "habit_marks"
        case groupMembers = "group_members"
    }
}

// MARK: - GroupMember
struct GroupMember: Codable {
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

// MARK: - HabitDetails
struct HabitDetails: Codable {
    let id: Int?
    let habitType: String?
    let days: [String]?
    let name, colorTheme, icon: String?
    let reminders: Bool?
    let habitDetailsDescription: String?
    let userID: Int?
    let timer: String?
    let createdAt, updatedAt: Int?
    let groupImage: String?
    let members: [Member]?

    enum CodingKeys: String, CodingKey {
        case id
        case habitType = "habit_type"
        case days, name
        case colorTheme = "color_theme"
        case icon, reminders
        case habitDetailsDescription = "description"
        case userID = "user_id"
        case timer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case groupImage = "group_image"
        case members
    }
}

// MARK: - HabitMark
struct HabitMark: Codable {
    let id, habitID: Int?
    let habitDay: Int?//String?
    let isCompleted: Bool?
    let createdAt, updatedAt: Int? // String?
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

// MARK: - ShowHabitDetail
//struct ShowHabitDetail: Codable {
//    let id: Int?
//    let habitType: String?
//    let days: [String]?
//    let name, colorTheme, icon: String?
//    let reminders: Bool?
//    let showHabitDetailDescription: String?
//    let userID: Int?
//    let timer: String?
//    let createdAt, updatedAt: Int?
//    let groupImage: String?
//    let members: [Member]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case habitType = "habit_type"
//        case days, name
//        case colorTheme = "color_theme"
//        case icon, reminders
//        case showHabitDetailDescription = "description"
//        case userID = "user_id"
//        case timer
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case groupImage = "group_image"
//        case members
//    }
//}

// MARK: - Member
struct Member: Codable {
    let id: Int?
    let email, encryptedPassword: String?
    let confirmationToken, resetPasswordToken, resetPasswordSentAt, rememberCreatedAt: String?
    let createdAt, updatedAt: Int?
    let verificationCode, authenticationToken, username: String?
    let memoji: String?
    let isVerified: Bool?
    let deviceType, osVersion, deviceModel, fcmToken: String?
    let forgotPassword: String?
    let deviceUdid: String?
    let loginType, socialID: String?
    let isGoogle, isApple: Bool?
    let profileImage: String?
    let habitMark: [HabitMark]?

    enum CodingKeys: String, CodingKey {
        case id, email
        case encryptedPassword = "encrypted_password"
        case confirmationToken = "confirmation_token"
        case resetPasswordToken = "reset_password_token"
        case resetPasswordSentAt = "reset_password_sent_at"
        case rememberCreatedAt = "remember_created_at"
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
        case profileImage = "profile_image"
        case habitMark = "habit_mark"
    }
}

// MARK: - JoinHabit
struct JoinHabit: Codable {
    let id, userID, habitID: Int?
    let member: [String]?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case habitID = "habit_id"
        case member
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - HabitCalender
struct HabitCalender: Codable {
    let id, habitID, habitDay: Int?
    let isCompleted: Bool?
    let createdAt, updatedAt, userID: Int?

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


