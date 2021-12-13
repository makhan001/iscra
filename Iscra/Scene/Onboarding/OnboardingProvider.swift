//
//  OnboardingProvider.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 05/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import Foundation

final class OnboardingServiceProvider: OnboardingServiceProvidable {
          
    var delegate: OnboardingServiceProvierDelegate?
    private let task = UserTask()

    func register(param:UserParams.Signup) {
        WebService().StartIndicator()
        task.signup(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .register, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .register, with: resp, with: nil)
        }
    }
    
    func login(param: UserParams.Login) {
        WebService().StartIndicator()
        task.login(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .login(resp?.message ?? "", resp?.data?.loginData?.isVerified ?? false), with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .login(resp?.message ?? "",  resp?.data?.loginData?.isVerified ?? false), with: resp, with: nil)
        }
    }

    func forgotPassword(param: UserParams.ForgotPassword) {
        WebService().StartIndicator()
        task.forgotPassword(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .forgotPassword(resp?.message ?? ""), with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .forgotPassword(resp?.message ?? ""), with: resp, with: nil)
        }
    }
    
    func changePassword(param: UserParams.ChangePassword) {
        WebService().StartIndicator()
        task.changePassword(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .changePassword(resp?.message ?? ""), with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .changePassword(resp?.message ?? ""), with: resp, with: nil)
        }
    }
    
    func socialLogin(param: UserParams.SocialLogin) {
        WebService().StartIndicator()
        task.socialLogin(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .socialLogin(resp?.message ?? ""), with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .socialLogin(resp?.message ?? ""), with: resp, with: nil)
        }
    }
    
    func verification(param: UserParams.Verification) {
        WebService().StartIndicator()
        task.verification(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .verification(resp?.message ?? ""), with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .verification(resp?.message ?? ""), with: resp, with: nil)
        }
    }
    
    func resendVerification(param: UserParams.ResendVerification) {
        WebService().StartIndicator()
        task.resendVerification(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .resendVerification, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .resendVerification, with: resp, with: nil)
        }
    }
    
    func logout(param: UserParams.logout) {
        WebService().StartIndicator()
        task.logout(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .logout, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .logout, with: resp, with: nil)
        }
    }
    
    func updateProfile(param: UserParams.UpdateProfile) {
        WebService().StartIndicator()
        task.updateProfile(params: param, responseModel: SuccessResponseModel.self) { [weak self](resp, err) in
            if err != nil {
                self?.delegate?.completed(for: .updateProfile, with: resp, with: err)
                return
            }
            self?.delegate?.completed(for: .updateProfile, with: resp, with: nil)
        }
    }
}

