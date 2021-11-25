//
//  extentions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//
//import Foundation
//
//enum APILoadingStatus : Equatable{
//    case isLoading
//    case failed(error : APIError)
//    case success
//    case none
//}
//
//enum APIError : Int {
//    case badRequest = 400
//    case notFound = 404
//    case serverError = 500
//    case unAuthorized = 401
//    case noInternetConnection 
//}
//
//enum API {
//    case Main
//    var url : String {
//        return APIConstants.ConfigUrls.basePath
//    }
//}
////enum Router {
////    case signUp([String:Any])
////    case logIn([String:Any])
////
////    var BaseUrl : String {
////        switch self {
////        case .signUp(_),
////             .logIn(_):
////
////            return API.Main.url
////        }
////    }
////
////    var Path: String {
////        switch self {
////
////        case .signUp(_):
////            return "signUp"
////        case .logIn(_):
////            return "signLogIn"
////        }
////    }
////
////    var FinalUrl : String {
////        let url = BaseUrl + Path
////        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
////    }
////}
//
