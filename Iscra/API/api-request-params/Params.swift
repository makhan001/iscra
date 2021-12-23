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
    //  let profile_image: String?
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
       // let user_id: String?
        let username: String?
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
      //  let habit_type: habitType = String?
        let color_theme: String?
        let description: String?
       // let group_image: String?
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
      //  let group_image: String?
    }
    
    struct DeleteHabit: Codable {
        let id: String?
    }
    
    struct HabitDetail: Codable {
        let id: String?
        let user_id: String?
        let habit_month: String?
    }
    
    struct AllHabitList: Codable {
    }
    
    struct GroupInvitations: Codable {
        let habit_id: String?
        let user_ids: [String]?
    }
    
    struct MarkAsComplete: Codable {
        let habit_id: String?
        let habit_day: String?
        let is_completed: String?
    }
    
    struct ShowHabit: Codable {
        let habit_id: String?
        let user_id: String?
    }
    
    struct JoinHabit: Codable {
        let habit_id: String?
    }
}

enum CommunityParams {
    struct FetchCommunity: Codable {
    }
    
    struct AllGroupHabit: Codable {
      //  let name: String?
    }
    
    struct Friends: Codable {
//let name: String?
    }
}
