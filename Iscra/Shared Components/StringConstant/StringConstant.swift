//
//  StringConstant.swift
//  Iscra
//
//  Created by Lokesh Patil on 12/11/21.
//

import UIKit
import Foundation

class AppConstant: NSObject {
    
    static let UserPlaceHolderImage = UIImage(named: "ic-user-placeholder")
    static let HabitPlaceHolderImage = UIImage(named: "ic-habit-placeholder")
    static let IscraAppLink = "https://apps.apple.com/us/app/iscra-group-habit-tracker/id1602472226" // https://apps.apple.com/us/app/itunes-connect/id376771144
   
    // SocialLogin Constants
    //  static let googleClientID = "39692170766-8vkfqscsq4ommlmsnrdmeld8knjne2ec.apps.googleusercontent.com"
    static let googleClientID = "537497635240-eiednf7mbhf7iv3s41f7c62okqak54mc.apps.googleusercontent.com"
    //Navigationtitle
    static let nav_addProfilePicture  = "Add Profile Picture"
    static let nav_memoji = "How to add your own memoji?"
    static let nav_shangpassword = "Change Password"
    
    // Alert Messages
    static let alert_emptynameMsg = "Please enter your name"
    static let shareAppMessage = "Iscra is a habit tracker app that helps you build good habits much easier and enjoyably together with other people."
    
    // IAPContent Messages
    static let IAPContent = "Length of subscription: Monthly (1 month).\n■  Payment will be charged to iTunes Account at confirmation of purchase.\n■  Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.\n■  Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal.\n■  Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase.\n■  Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable."
    
    // Chat Password
    static let defaultQBUserPassword = "Iscra@123"
    
    static let USERNAME_ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-"
    
    
    //Onboarding --
    static let welComeDiscription  = "We help people to become the best version of themself and connect with others people"
    static let onbordingName  = "How do your \nfriends call you?"
    static let HeaderTitle = "How to add your own memoji?"
    static let Sub1Title = "Open Notes on your iPhone. Click a new note.  "
    static let Sub2Title = "Tap the Memoji button then swipe right and tap the New Memoji add new memoji button."
    static let Sub3Title = "Share your memoji to your notes then click the memoji and save it to your gallery."
    static let signUpHeaderTitle = "Let’s create your \naccount"
    static let otpHeaderTitle = "Verify email"
    static let otpMiddleTittle = "Enter the confirmation \ncode we sent to 'email'."
    static let loginHeaderTitle = "Log in into your \naccount"
    static let subscriptionTitle = "Thanks for using our app and making yourself and others better people. Unfortunately, for our development we need money. You can subscribe for $0.99 per month."
    
    //WebView
    static let termsAndConditionTitle = "Terms And Condition"
    static let privacyPolicyTitle = "Privacy Policy"
    static let aboutUsTitle = "About Us"
    static let termsAndConditionURL = "https://www.iscra.app/terms-conditions"
    static let privacyPolicyURL = "https://www.iscra.app/privacy-policy"
    static let aboutUsURL = "https://www.iscra.app/about-us"
    
    static let firstHabitTitle = "Are you ready to create \nyour first habit?"
    static let firstHabitSubTitle = "I am excited to help you to become \na better version of yourself. Let's \nstart our journey. Click plus button \nto create your first habit."
    static let goodHabitTitle = ", let’s define your habit"
    static let badHabitTitle = "! I will help you to get rid of bad habit"
    static let groupHabitTitle = "Let’s become better together"
    
    static let inviteFriendsGoodTitle = "Together is \nmore fun"
    static let inviteFriendsGoodSubTitle = "Do you know it’s much easier to build a \nnew habits when your friend can support \nyou. Invite your friends, build good habits \ntogether and have fun!"
    static let inviteFriendsBadTitle = "Together we \nare stronger"
    static let inviteFriendsBadSubTitle = "It’s much easier to get rid of bad habits \ntogether! Support each other to become \nbetter people."
    
    static let inviteFriendsGroupTitle = "Let’s invite \nyour friends"
    static let inviteFriendsGroupSubTitle = "Invite your friends, build good habits \ntogether and have fun (if your friends are \nalready with Iscra, they can find your habit \nin search and join you). You can make your \ngroup public and find new friends!"

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

