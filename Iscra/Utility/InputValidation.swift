//
//  extentions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation
enum InputValidation:String {
    case name
    case description
    case email
    case password
}

class Validation {
    
    func textValidation(text:String,validationType:InputValidation) -> (Bool,String) {
        
        switch validationType {
        
        case .email:
            return(
                text == "" ? true :
                    Validation().isValidEmail(emaiId: text) == false ? true : false,
                text == "" ? AppConstant.emptyEmail :AppConstant.invaliedEmail)
            
        case .password:
            return(
                text == "" ? true :
                    text.count < 6 ? true : false,
                text == "" ? AppConstant.emptyPassword : AppConstant.invaliedPassword)
            
        case .name:
            return( text == "" ? true :
                        isTextContainspecialCharacters(string: text) == true ? true : false,
                    text == "" ? "Field cant be empty" : "Please enter valid name")
            
        case .description:
            return( text == "" ? true :
                        text.count > 140 ? true : false,
                    text == "" ? "Field cant be empty" : "Not more than 140 words")
            
        
        }
    }
    
    func isValidEmail(emaiId:String) -> Bool {
        let emailRegEx = NSPredicate(format: "SELF MATCHES %@",
                                     "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailRegEx.evaluate(with: emaiId)
    }
    
    // Passwords Validations
    
    func isValidPassword(password:String) -> Bool{
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    // Special Characters Validations
    func isTextContainspecialCharacters(string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[^a-z0-9 ]", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) {
                return true
            } else {
                return false
            }
        } catch {
            debugPrint(error.localizedDescription)
            return true
        }
    }
    
}

