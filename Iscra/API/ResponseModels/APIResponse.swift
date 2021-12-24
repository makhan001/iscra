//
// Responses.swift
// CallRecording
//
// Created by Mohd Ali Khan on 21/07/2020.
// Copyright © 2020 cis. All rights reserved.
//
import Foundation
struct SuccessResponseModel: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let data: DataClass?
}
// MARK: - DataClass
struct DataClass: Codable {
    var register: Register?
    var loginData: LoginData?
    var forgotPassword: String?
    var url: String?
    var verificationCode: Int?
    var user: User?
    var habit: Habit?
    var habits: [AllHabits]?
    var habitDetails: HabitDetails?
    let showHabitDetails: ShowHabitDetail?
    var habitMark: HabitMark?
    let groupHabits: [GroupHabit]?
    let invitaions: [Invitaion]?
    let friends: [Friend]?
    let joinHabit: JoinHabit?
    let allGroupHabits: [AllGroupHabit]?// [GroupHabit]?
    enum CodingKeys: String, CodingKey {
        case register, user, habit, habits, url, invitaions, friends //, groupdetails
        case loginData = "login_data"
        case forgotPassword = "forgot_password"
        case verificationCode = "verification_code"
        case habitDetails = "habit_details"
        case habitMark = "habit_mark"
        case groupHabits = "group_habits"
        case allGroupHabits = "all_group_habits"
        case joinHabit = "join_habit"
        case showHabitDetails = "show_habit_details"
    }
}

// MARK: - Register
struct Register: Codable {
    let id: Int
    let email, encryptedPassword: String
    let confirmationToken, resetPasswordToken, resetPasswordSentAt, rememberCreatedAt: JSONNull?
    let createdAt, updatedAt: Int
    let verificationCode, authenticationToken, username: String
    let memoji: JSONNull?
    let isVerified: Bool
    let deviceType, osVersion, deviceModel, fcmToken: String
    let forgotPassword: JSONNull?
    let deviceUdid: String
    let loginType, socialID: JSONNull?
    let isGoogle, isApple: Bool
    let profileImage: String
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
    }
}
// MARK: - LoginData
struct LoginData: Codable {
    var id: Int?
    var email, encryptedPassword: String?
    var confirmationToken, resetPasswordToken, resetPasswordSentAt, rememberCreatedAt: JSONNull?
    var createdAt, updatedAt: Int?
    var verificationCode, authenticationToken, username: String?
    var memoji: JSONNull?
    var isVerified: Bool?
    var deviceType, osVersion, deviceModel, fcmToken: String?
    var forgotPassword: JSONNull?
    var deviceUdid: String?
    var loginType, socialID: JSONNull?
    var isGoogle, isApple: Bool?
    var profileImage: String?
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
    }
}

//Mark:- UserData
struct User: Codable {
    var id: Int?
    var email, encryptedPassword: String?
    var confirmationToken, resetPasswordToken, resetPasswordSentAt, rememberCreatedAt: JSONNull?
    var createdAt, updatedAt: Int?
    var verificationCode, authenticationToken, username: String?
    var memoji: JSONNull?
    var isVerified: Bool?
    var deviceType, osVersion, deviceModel, fcmToken: String?
    var forgotPassword: JSONNull?
    var deviceUdid: String?
    var loginType, socialID: JSONNull?
    var isGoogle, isApple: Bool?
    var profileImage: String?

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
    }
}
