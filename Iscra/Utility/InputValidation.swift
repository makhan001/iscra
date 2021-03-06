//
//  extentions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation
enum InputValidation:String {
    case name
    case email
    case password
    case habitName
    case description
    case newPassword
    case currentPassword
    case confirmPassword
//    case icon
//    case colorTheme
}

class Validation {
    
    func textValidation(text:String,validationType:InputValidation) -> (Bool,String) {
        switch validationType {        
        case .email:
            return(
                text == "" ? true :
                    Validation().isValidEmail(emaiId: text) == false ? true : false,
                text == "" ? AppConstant.emptyEmail :AppConstant.invalidEmail)
            
        case .password:
            return(
                text == "" ? true :
                    text.count < 6 ? true : false,
                text == "" ? AppConstant.emptyPassword : AppConstant.invalidPassword)
            
        case .newPassword:
            return(
                text == "" ? true :
                    text.count < 6 ? true : false,
                text == "" ? AppConstant.emptyNewPassword : AppConstant.invalidNewPassword)
            
        case .currentPassword:
            return(
                text == "" ? true :
                    text.count < 6 ? true : false,
                text == "" ? AppConstant.emptyCurrentPassword : AppConstant.invalidCurrentPassword)
            
        case .confirmPassword:
            return(
                text == "" ? true :
                    text.count < 6 ? true : false,
                text == "" ? AppConstant.emptyConfirmPassword : AppConstant.invalidConfirmPassword)
            
        case .name:
            return( text == "" ? true :
                       Validation().isValidname(name: text) == false ? true : false,
                    text == "" ? AppConstant.emptyName : AppConstant.invalidName)
            
        case .description:
            return( text == "" ? true :
                        text.count > 140 ? true : false,
                    text == "" ? AppConstant.emptyDescription : AppConstant.invalidDescription)
            
        case .habitName:
            return( text == "" ? true :
                        text.count > 30 ? true : false,
                    text == "" ? AppConstant.emptyHabitName : AppConstant.invalidHabitName)
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
    func isValidname(name:String) -> Bool {
        let nameRegEx = NSPredicate(format: "SELF MATCHES %@",
                                     "^[a-zA-Z]-_")
        return nameRegEx.evaluate(with: name)
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

