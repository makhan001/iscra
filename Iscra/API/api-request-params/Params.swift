//
//  Params.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 14/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation

enum UserParams {
    
    struct Signup:Codable {
        let email:String?
        let username:String?
        let password:String?
        let fcm_token:String?
        let device_id:String?
        let device_type:String?
    }
    
    struct Login:Codable {
        let email:String?
        let password:String?
        let fcm_token:String?
        let device_id:String?
        let device_type:String?
    }
    
    struct ForgotPassword:Codable {
        let email:String?
    }
    
    struct Verification:Codable {
        let verification_code:String?
    }
    
    struct ChangePassword:Codable {
        let user_id:String?
        let old_password:String?
        let new_password:String?
    }
    
    struct SocialLogin:Codable {
        let type:SocialLoginType?
        let social_id:String?
        let username:String?
        let email:String?
        let fcm_token:String?
        let image_url:String?
        let device_id:String?
        let device_type:String?
    }
    
    struct UpdateProfile:Codable {
        let user_id:String?
        let username:String?
    }
}

enum SocialLoginType: String, Codable {
    case google = "1"
    case apple = "2"
    case facebook = "3"
}


