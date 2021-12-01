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
        let type: SocialLoginType?
        let social_id: String?
        let username: String?
        let email: String?
        let fcm_token: String?
        let image_url: String?
        let device_id: String?
        let device_type: String?
    }
    
    struct UpdateProfile: Codable {
       // let user_id: String?
        let username: String?
        
    }
}

enum SocialLoginType:  String, Codable {
    case google = "1"
    case apple = "2"
    case facebook = "3"
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
        let reminders: String?
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
    }
    
    struct AllHabitList: Codable {
    }
}
