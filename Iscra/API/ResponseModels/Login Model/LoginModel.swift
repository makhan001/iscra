//
//  LoginModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 19/10/21.
//

import Foundation

//struct LoginModel {
//    
//    var code : Int = -1
//    var message : String = ""
//    var data : LoginDataModel  = LoginDataModel()
//    
//    init() {}
//    
//    init(response : [String : Any]) {
//        
//        if let code = response["code"] as? Int {
//            self.code = code
//        }
//        
//        if let message = response["message"] as? String {
//            self.message = message
//        }
//        
//        if let data = response["data"] as? [String : Any] {
//            self.data = LoginDataModel( response : data )
//        }
//    }
//}
//
//struct LoginDataModel {
//    var login_data : LoginData  = LoginData()
//    
//    init() {}
//    
//    init(response : [String : Any]) {
//        
//        if let login_data = response["login_data"] as? [String : Any] {
//            self.login_data = LoginData( response : login_data )
//        }
//        
//    }
//}
//
//struct LoginData {
//    
//    var token : String = ""
//    
//    init() {}
//    
//    init(response : [String : Any]) {
//        
//        if let token = response["token"] as? String {
//            self.token = token
//        }
//        
//    }
//}
