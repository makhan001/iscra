//
//  Params.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 14/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation

enum UserParams {
    
    struct Signup: Codable {
        let email: String?
        let username: String?
        let password: String?
        let fcm_token: String?
        let os_version: String?
        let device_model: String?
        let device_udid: String?
        let device_type: String?
    }
    
    struct Login: Codable {
        let email: String?
        let password: String?
        let fcm_token: String?
        let os_version: String?
        let device_model: String?
        let device_udid: String?
        let device_type: String?
    }
    
    struct ForgotPassword: Codable {
        let email: String?
    }
    
    struct Verification: Codable {
        let verification_code: String?
    }
    
    struct ResendVerification: Codable {
    }
    
    struct logout: Codable {
    }
    
    struct ChangePassword: Codable {
        let current_password: String?
        let new_password: String?
    }
    
    struct SocialLogin: Codable {
        let email: String?
        let username: String?
        let social_id: String?
        let fcm_token: String?
        let device_udid: String?
        let device_type: String?
        let os_version: String?
        let device_model: String?
        let login_type: SocialLoginType?
    }
    
    struct UpdateProfile: Codable {
        let username: String?
        var is_subscribed: Bool = false
    }
    
    struct Subscription: Codable {
        let user_id: Int?
        let transaction_date: Int?
        let transaction_type: String?
        let transaction_amount: String?
        let transaction_identifier: String?
    }
}

enum SocialLoginType:  String, Codable {
    case google = "0"
    case apple = "1"
    case facebook = "2"
}

enum HabitParams {
    
    struct CreateHabit: Codable {
        let days: String?
        let icon: String?
        let name: String?
        let timer: String?
        let reminders: Bool?
        let habit_type: String?
        let color_theme: String?
        let description: String?
    }
    
    struct UpdateHabit: Codable {
        let id: String?
        let days: String?
        let icon: String?
        let name: String?
        let timer: String?
        let reminders: Bool?
        let habit_type: String?
        let color_theme: String?
        let description: String?
    }
    
    struct DeleteHabit: Codable {
        let id: String?
    }
    
    struct HabitCalender: Codable {
        let habit_id: Int?
        let user_id: Int?
        let habit_month: Int?
    }
    
    struct GroupHabitDetails: Codable {
        let habit_id: Int?
    }
    
    struct GroupHabitMembers: Codable {
        let habit_id: Int?
    }
    
    struct HabitDetail: Codable {
        let habit_id: Int?
        let user_id: Int?
    }
    
    struct AllHabitList: Codable {
    }
    
    struct ShareHabit: Codable {
        let habit_id: Int?
        let user_ids: [Int]?
    }
    
    struct MarkAsComplete: Codable {
        let habit_id: String?
        let habit_day: String?
        let is_completed: String?
    }
        
    struct JoinHabit: Codable {
        let habit_id: String?
    }
    
    struct Friends: Codable {
        let search: String?
    }
    
    struct UpdateSubscription: Codable {
        var is_subscribed: Bool = false
    }
    
    struct GetSubscription: Codable {
    }
}

enum CommunityParams {
    
    struct FetchCommunity: Codable {
    }
    
    struct AllGroupHabit: Codable {
        let search: String?
    }
    
    struct Friends: Codable {
        let search: String?
    }
    
    struct GroupHabitMembers: Codable {
        let habit_id: Int?
    }
}
