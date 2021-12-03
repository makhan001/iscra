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
    var user: User?
    var habit: Habit?
    var habits: [AllHabits]?
    enum CodingKeys: String, CodingKey {
        case register, user, habit, habits
        case loginData = "login_data"
        case forgotPassword = "forgot_password"
    }
}
// MARK: - Register
struct Register: Codable {
    var id: Int?
    var email, createdAt, updatedAt, verificationCode: String?
    var authenticationToken, username, profileImage: String?
    var memoji: JSONNull?
    var isVerified: Bool?
    var deviceType, osVersion, deviceModel, fcmToken: String?
    var forgotPassword: JSONNull?
    var deviceUdid: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case verificationCode = "verification_code"
        case authenticationToken = "authentication_token"
        case username
        case profileImage = "profile_image"
        case memoji
        case isVerified = "is_verified"
        case deviceType = "device_type"
        case osVersion = "os_version"
        case deviceModel = "device_model"
        case fcmToken = "fcm_token"
        case forgotPassword = "forgot_password"
        case deviceUdid = "device_udid"
    }
}
// MARK: - LoginData
struct LoginData: Codable {
    let email, deviceType, osVersion, deviceModel: String?
    let fcmToken, deviceUdid: String?
    let id: Int?
    let createdAt, updatedAt, verificationCode, authenticationToken: String?
    let username: String?
    let profileImage, memoji: String?
    let isVerified: Bool?
    let forgotPassword: String?
    enum CodingKeys: String, CodingKey {
        case email
        case deviceType = "device_type"
        case osVersion = "os_version"
        case deviceModel = "device_model"
        case fcmToken = "fcm_token"
        case deviceUdid = "device_udid"
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case verificationCode = "verification_code"
        case authenticationToken = "authentication_token"
        case username
        case profileImage = "profile_image"
        case memoji
        case isVerified = "is_verified"
        case forgotPassword = "forgot_password"
    }
}
//Mark:- UserData
struct User: Codable {
    let username, email: String?
    let id: Int?
    let createdAt, updatedAt, verificationCode, authenticationToken: String?
    let profileImage: String?
    let memoji: JSONNull?
    let isVerified: Bool?
    let deviceType, osVersion, deviceModel, fcmToken: String?
    let forgotPassword: JSONNull?
    let deviceUdid: String?
    let loginType, socialID: JSONNull?
    let isGoogle, isApple: Bool?
    enum CodingKeys: String, CodingKey {
        case username, email, id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case verificationCode = "verification_code"
        case authenticationToken = "authentication_token"
        case profileImage = "profile_image"
        case memoji
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
