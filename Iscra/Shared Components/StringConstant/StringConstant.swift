//
//  StringConstant.swift
//  Iscra
//
//  Created by Lokesh Patil on 12/11/21.
//

import Foundation
import UIKit

class AppConstant: NSObject {
    
    //Navigationtitle
    static let nav_addProfilePicture  = "Add Profile Picture"
    static let nav_memoji = "How to add your own memoji?"
    static let nav_shangpassword = "Change Password"
    
    // Alert Messages
    static let alert_emptynameMsg = "Please enter your name"
    
    
    //Onboarding --
    static let welComeDiscription  = "We help people to become the best version of themself and connect with others people"
    
    static let onbordingName  = "How do your \nfriends call you?"
    
    static let HeaderTitle = "How to add your own memoji?"
    static let Sub1Title = "Open Notes on your iPhone. Click a new note."
    static let Sub2Title = "Tap the Memoji button then swipe right and tap the New Memoji add new memoji button."
    static let Sub3Title = "Share your memodji to your notes then click the memoji and save it to your gallery."
    
    static let signUpHeaderTitle = "Let’s create your \naccount"
    static let otpHeaderTitle = "Verify email"
    static let otpMiddleTittle = "Enter the confirmation \ncode we sent to 'email'."
    
    static let loginHeaderTitle = "Log in into your \naccount"
    
    static let subscriptionTitle = "Thanks for using our app and making yourself and others better people. Unfortunately, for our development we need money. You can choose between two options: subscribe for one dollar per month or allow ads."
    
    
    
    // MARK:Validation Alert messages
    static let emptyEmail = "Email is required"
    static let invalidEmail = "Please enter valid email"
    static let emptyPassword = "Password is required"
    static let emptyNewPassword = "New password is required"
    static let invalidPassword = "Please enter valid password"
    static let invalidNewPassword = "Please enter valid new password"
    static let emptyCurrentPassword = "Current password is required"
    static let emptyConfirmPassword = "Confirm password is required"
    static let invalidCurrentPassword = "Please enter valid current password"
    static let invalidConfirmPassword = "Please enter valid confirm password"
    static let invalidCurrentPasswordMatch = "Current password and new password are not same"
    static let invalidConfirmPasswordMatch = "New password and confirm password are not match"
    static let emptyDays = "Please select days"
    static let emptyGroupImage = "Please select group image"
    static let deleteHabit = "Are you sure? The habit will be permanently deleted."
    static let emptyName = "name can't be empty"
    static let invalidName = "Please enter valid name"
    static let emptyDescription = "Description cant be empty"
    static let invalidDescription = "Description not more than 140 words"
    static let emptyHabitName = "Habit name can't be empty"
    static let invalidHabitName = "Habit name not more than 30 words"
}

