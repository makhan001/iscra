////
////  SignUpModel.swift
////  Iscra
////
////  Created by Lokesh Patil on 14/10/21.
////
//
//import Foundation
//
//struct SignUpModel {
//    var status : Bool = false
//    var code : Int = -1
//    var signUpData : SignUpUserData  = SignUpUserData()
//    
//    init() {}
//    
//    init(response : [String : Any]) {
//        
//        if let status = response["status"] as? Bool {
//            self.status = status
//        }
//        
//        if let code = response["code"] as? Int {
//            self.code = code
//        }
//        
//        if let data = response["data"] as? [String : Any] {
//            self.signUpData = SignUpUserData( response : data )
//        }
//    }
//}
//
//struct SignUpUserData {
//    var user : User  = User()
//    
//    init() {}
//    
//    init(response : [String : Any]) {
//        
//        if let user = response["user"] as? [String : Any] {
//            self.user = User( response : user )
//        }
//    }
//}
//
//struct User {
//    var id : Int = -1
//    var email : String = ""
//    var createdAt : String = ""
//    var updatedAt : String = ""
//    var authenticationToken : String = ""
//    
//    init() {}
//    
//    init(response : [String : Any]) {
//        
//        if let id = response["id"] as? Int {
//            self.id = id
//        }
//        
//        if let email = response["email"] as? String {
//            self.email = email
//        }
//        
//        if let created_at = response["created_at"] as? String {
//            self.createdAt = created_at
//        }
//        
//        if let updated_at = response["updated_at"] as? String {
//            self.authenticationToken = updated_at
//        }
//        
//        if let authentication_token = response["authentication_token"] as? String {
//            self.authenticationToken = authentication_token
//        }
//    }
//}
