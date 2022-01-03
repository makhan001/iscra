//
//  extentions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation

let BAD_REQUEST_ERROR_MESSAGE = "Incorrect request by user"
let NETWORK_ERROR_MESSAGE = "Please check you internet connection"
let SERVER_ERROR_MESSAGE = "Server is not available try later"
let AUTHORISATION_ERROR_MESSAGE = "You are not authorized, please login again"
let PARSING_ERROR_MESSAGE = "Request response is incorrect parse issue"
let ERROR_MESSAGE = "Something went wrong"

struct APIConstants {
    
    struct ConfigUrls {
        static let basePath = "https://api.openweathermap.org/data/2.5/"
        static let rapidapiHost =  "weatherapi-com.p.rapidapi.com"
        static let rapidapiKey = "820ecb3f09msh531d2e35d11a683p127cb1jsne032d4ad6138"
    }
    
    static let editHabit =  "habits/edit"
    static let addHabit =  "habits/add_habit"
    static let updateProfile =  "users/update"
    static let socialLogin = "users/sociallogin"
    static let userRegister =  "users/registration"
}

