//
//  LoginViewModel.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation

class LoginViewModel : NSObject {
    
    var LoginStatus  : APILoadingStatus = .isLoading
    var LoginData : LoginModel!
    var isVaildEmail = false
    var isVaildPassword = false
    var errorMsg = ""
    
    override init() {
        super.init()
    }
    
    //
    //MARK:- API Calling
    //
    
    func Login(emailId:String,password:String,success: @escaping () -> Void) {
        var params : [String : Any] = [:]
        params.updateValue(emailId, forKey: "email")
        params.updateValue(password, forKey: "password")
        self.LoginStatus = .isLoading
        WebserviceManager.shared.sendRequest(serviceType: .logIn, params: params) { (response) in
            if let resp = response as? [String : Any] {
                let data = LoginModel(response: resp)
                self.LoginData = data
                success()
            }
            self.LoginStatus = .success
        } failure: { (error) in
            self.LoginStatus = .failed(error: .notFound)
            print("LoginStatus error")
            
        } offline: { (error) in
            print("LoginStatus network error")
            self.LoginStatus = .failed(error:.noInternetConnection )
        }
    }
    
    //
    //MARK:- Validations
    //
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












