//
//  AddHabitViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 12/11/21.
//

import Foundation

struct UserStore {
    private static let userData = "userData"
    private static let token_key = "token"
    private static let phone_key = "phone"
    private static let country_key = "country"
    private static let userIdKey = "user_id"
    private static let userImageKey = "user_image"
    private static let name_key = "name"
    private static let email_key = "email"
    private static let customer_key = "stripe_customer"
    private static let primeUserKey = "primeUser"
    private static let is_social_login_key = "is_social_login"
    private static let empkey = "emp"
    
    static let fcmtoken_key = "fcmtoken"
    static let apns_token_key = "apns_token"
    static let socialLoginKey = "social_login_key"

    static var userDetail: LoginData? {
        return UserDefaults.standard.object(forKey: userData) as! LoginData
    }
    
    static var token: String? {
        return UserDefaults.standard.string(forKey: token_key)
    }
    
    static var emp: String? {
        return UserDefaults.standard.string(forKey: empkey)
    }

    static var primeUser: Bool? {
        return UserDefaults.standard.bool(forKey: primeUserKey)
    }
    
    static var phoneNo: String? {
        return UserDefaults.standard.string(forKey: phone_key)
    }
    
    static var countryCode: String? {
        return UserDefaults.standard.string(forKey: country_key)
    }
    
    static var apnsToken: String? {
        return UserDefaults.standard.string(forKey: apns_token_key)
    }
    
    static var fcmtoken: String? {
        return UserDefaults.standard.string(forKey: fcmtoken_key)
    }
    
    static var userID:String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }
    
    static var userImage:String? {
        return UserDefaults.standard.string(forKey: userImageKey)
    }
    
    static var userName:String? {
        return UserDefaults.standard.string(forKey: name_key)
    }
    
    static var userEmail:String? {
        return UserDefaults.standard.string(forKey: email_key)
    }
    
    static var stripeCustomerId:String? {
        return UserDefaults.standard.string(forKey: customer_key)
    }
    
    static var isSocialLogin:Bool? {
        return UserDefaults.standard.bool(forKey: is_social_login_key)
    }

    static func save(token:String?) {
        UserDefaults.standard.set(token, forKey: token_key)
    }
    
    static func save(primeUser:Bool?) {
        UserDefaults.standard.set(primeUser, forKey: primeUserKey)
    }

    static func save(phoneNo:String?) {
        UserDefaults.standard.set(phoneNo, forKey: phone_key)
    }
    
    static func save(countryCode:String?) {
        UserDefaults.standard.set(countryCode, forKey: country_key)
    }
    
    static func save(apnsToken:String?) {
        UserDefaults.standard.set(apnsToken, forKey: apns_token_key)
    }
    
    static func save(fcmtoken:String) {
        UserDefaults.standard.set(fcmtoken, forKey: fcmtoken_key)
    }
    
    static func save(userID:String?) {
        UserDefaults.standard.set(userID, forKey: userIdKey)
    }
    
    static func save(userImage:String?) {
        UserDefaults.standard.set(userImage, forKey:userImageKey)
    }
    
    static func save(userName:String?) {
        UserDefaults.standard.set(userName, forKey:name_key)
    }
    
    static func save(userEmail:String?) {
        UserDefaults.standard.set(userEmail, forKey:email_key)
    }
    
    static func save(emp:String?) {
        UserDefaults.standard.set(emp, forKey:empkey)
    }
    
    static func save(stripeCustomerId:String?) {
        UserDefaults.standard.set(stripeCustomerId, forKey:customer_key)
    }
    
    static func save(isSocialLogin:Bool) {
        UserDefaults.standard.set(isSocialLogin, forKey:is_social_login_key)
    }
    
    static func save(userDetail:LoginData?) {
        UserDefaults.standard.set(userDetail.self, forKey:userData)
    }
    
//    static func save(dialHistory:[DialHistory]) {
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(dialHistory), forKey:dialHistoryKey)
//    }
//    
//    static func save(recordingFolder:[RecordingFolder]) {
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(recordingFolder), forKey:recordingFolderKey)
//    }
}
