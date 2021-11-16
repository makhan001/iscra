
//
//  Responses.swift
//  CallRecording
//
//  Created by Mohd Ali Khan on 21/07/2020.
//  Copyright © 2020 cis. All rights reserved.
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
    
    let register: Register?
    enum CodingKeys: String, CodingKey {
        case register
    }
}

// MARK: - Register
struct Register: Codable {
    var id: Int?
    var email, createdAt, updatedAt: String?
    var verificationCode: Int?
    var authenticationToken: String?

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case verificationCode = "verification_code"
        case authenticationToken = "authentication_token"
    }
}



