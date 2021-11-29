//
//  UserRequests.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 05/12/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import UIKit

struct UserRequests:RequestRepresentable {
    
    let requestType: RequestType
    enum RequestType {
        case profile
        case edit
        case search
        case update
        case logout
    }
    
    init(requestType: RequestType) {
        self.requestType = requestType
    }
    
//    init(type: RequestType, params:Codable) {
//        self.requestType = type
//        switch params {
//        case: break
//        default:break
//        }
//    }
    
    var method: HTTPSMethod {
        switch requestType {
        case .profile, .logout:
            return .get
        
        default:
            return .post
        }
    }
    
    var endpoint: String {
        switch self.requestType {
        case .profile:
            return "users/get_profile"
        case .edit:
            return "users/profile"
        case .search:
            return "users/profile"
        case .update:
            return "users/updateprofile"
        case .logout:
            return "users/logout"
        }
    }
    
    var parameters: Parameters {
        return .none
    }
}
