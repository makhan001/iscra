//
//  extentions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation
import SwiftUI
enum InputValidation:String {
    case name
    case firstName
    case lastName
    case description
    case email
    case phoneNumber
    case website
    case location = "Location"
    case country = ""
    case password
}

class Validation {
    
    func textValidation(text:String,validationType:InputValidation) -> (Bool,String) {
        
        switch validationType {
        
        case .name:
            return( text == "" ? true :
                        isTextContainspecialCharacters(string: text) == true ? true : false,
                    text == "" ? "Field cant be empty" : "Please enter valid name")
            
        case .firstName:
            return( text == "" ? true :
                       isTextContainspecialCharacters(string: text) == true ? true : false,
                    text == "" ? "Field cant be empty" : "Please enter valid first name")
        
        case .lastName:
            return( text == "" ? true :
                      isTextContainspecialCharacters(string: text) == true ? true : false,
                    text == "" ? "Field cant be empty" : "Please enter valid last name")
            
        
            
        case .description:
            return( text == "" ? true :
                        text.count > 140 ? true : false,
                    text == "" ? "Field cant be empty" : "Not more than 140 words")
            
        case .email:
            
            return(
                text == "" ? true :
                    Validation().isValidEmail(emaiId: text) == false ? true : false,
                text == "" ? "Field cant be empty" : "Please enter vaild email")
          
        case .phoneNumber:
            return(
                text == "" ? true :
                    text.count < 8 ? true : false,
                text == "" ? "Field cant be empty" : "Please enter valid number")
        case .website:
            if text == ""{
                return(false,"")
            }
            else if  text.isValidURL() == false
            {
                return(true,"Please enter valid url")
            }
            else{
                return(false,"")
            }
        
        case .location:
            return ( text == "" ? true : false ,  "Please select the country")
            
        case .country:
            return ( text == "" ? true : false ,  "Please select the country Code")
    
        case .password:
            return(
                text == "" ? true :
                    text.count < 6 ? true : false,
                text == "" ? "Please enter password" : "Please enter vaild password")
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

    // Check String Intiger Characters Validations
    func checkString(acceptCharSet: CharacterSet, IgnoreCharSet:  CharacterSet,oldValue: String) -> (isInvaild:Bool, newValue: String){
        let ignoreRange = oldValue.rangeOfCharacter(from: IgnoreCharSet)
        if ignoreRange != nil {
            let  str = oldValue
            let value = str.trimmingCharacters(in: acceptCharSet.inverted)
            return (true, String(value))
        }
        return(false,"")
    }
    
    func isValidCompanyName(string:String) -> Bool {
        do { //"[^A-Za-z0-9./\\&-/\\' ]"
//            "^[&]?[a-zA-Z0-9 ]+[ \\-.&()]?[ a-zA-Z0-9!()]$"
            let regex = try NSRegularExpression(pattern: "[^A-Za-z0-9./\\&-/\\' ]", options: .caseInsensitive)
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

extension String {

    func isValidURL() -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    func isSocialContains(ContainsText:String)->Bool{
        if self.contains(ContainsText){
            return true
        }
        return false
    }
    
}
