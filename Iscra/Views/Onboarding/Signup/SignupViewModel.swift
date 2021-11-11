//
//  SignupViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation

class SignUpViewModel : NSObject {
    
    var signUpStatus  : APILoadingStatus = .isLoading
    var signUpData : SignUpModel!
    var isVaildEmail = false
    var isVaildPassword = false
    var errorMsg = ""
    
    override init() {
        super.init()
    }
    
    //
    //MARK:- API Calling
    //
    
    func signUp(emailId:String,password:String,success: @escaping () -> Void) {
        var params : [String : Any] = [:]
        params.updateValue(emailId, forKey: "email")
        params.updateValue(password, forKey: "password")
        
        self.signUpStatus = .isLoading
        WebserviceManager.shared.sendRequest(serviceType: .signUp, params: params) { (response) in
            if let resp = response as? [String : Any] {
                let data = SignUpModel(response: resp)
                self.signUpData = data
                success()
            }
            self.signUpStatus = .success
            print("signUpStatus Success")
            
        } failure: { (error) in
            self.signUpStatus = .failed(error: .notFound)
            print("signUpStatus error")
            
        } offline: { (error) in
            print("signUpStatus network error")
            self.signUpStatus = .failed(error:.noInternetConnection )
        }
    }
    
    func ValidateUserInputs(emailId:String,password:String) -> Bool {
        var isVaild = true
        if Validation().textValidation(text: emailId, validationType: .email).0{
            isVaild = false
            errorMsg = Validation().textValidation(text: emailId, validationType: .email).1
        }
        else if Validation().textValidation(text: password, validationType: .password).0{
            isVaild = false
            errorMsg = Validation().textValidation(text: emailId, validationType: .password).1
        }
        else{
            isVaild = true
        }
        return isVaild
    }
}












