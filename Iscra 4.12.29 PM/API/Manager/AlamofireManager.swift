//
//  extentions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation
import Alamofire


//class AlamofireManager : NSObject {
//    
//    static let shared = AlamofireManager()
//    //Mark:- private let alamofireManager : AF.session
//    
//    let unAuthorizedError = NSError(domain: "UnAuthorized", code: 401, userInfo: nil)
//    let badRequestError = NSError(domain: "BadRequest", code: 400, userInfo: nil)
//    let serverError = NSError(domain: "InternalServerError", code: 500, userInfo: nil)
//    private override init() {
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForResource = 60
//        configuration.timeoutIntervalForRequest = 60
//    }
//    func makeAPIRequest(urlRequest : String, parameters : Parameters?, methodType : Alamofire.HTTPMethod, encodingType : ParameterEncoding,  headers : HTTPHeaders?,
//                        success : @escaping ([String : Any]) -> Void, failure : @escaping (Error) -> Void){
//        
//        print("\n----- REQUEST ------")
//        print("\nURL : \(urlRequest)")
//        print("\nHEADERS : \(headers ?? HTTPHeaders.init([:]))")
//        print("\nPARAMETERS : \(parameters ?? [:])")
//
//        AF.request(urlRequest, method: methodType, parameters: parameters, encoding: encodingType, headers: headers).responseJSON { [weak self] (response) in
//            
//            print("\n----- RESPONSE ------")
//            print("\nSTATUS_CODE : \(response.response?.statusCode ?? -1001)")
//            print("\nURL : \(urlRequest)")
//            print("\nPARAMETERS : \(parameters ?? [:])")
//            print("\nRESPONSE : \(response)")
//            print("\n----- RESPONSE END ------\n")
//            let defaultError = NSError.init(domain: "default error", code: 400, userInfo: nil)
//            
//            guard let statusCode = response.response?.statusCode else {
//                print("Cannot cast Status code")
//                failure(self?.badRequestError ?? defaultError)
//                return
//            }
//            // Handle Error cases
//            switch statusCode {
//            
//            case 401, 403 :
//                return
//            case 400..<500 :
//                failure(self?.badRequestError ?? defaultError)
//            case 500:
//                failure(self?.serverError ?? defaultError)
//                return
//                
//            default:
//                print("")
//            }
//            
//            switch response.result {
//            
//            case .success(let value) :
//                
//                guard let statusCode = response.response?.statusCode else {
//                    print("NO STATUS CODE PRESENT!! RETURNING!! ")
//                    return
//                }
//                
//                switch statusCode {
//                
//                case 200..<300 :
//                    if let responseDict = value as? [String : Any] {
//                        success(responseDict)
//                    }
//                default :
//                    failure(self?.badRequestError ?? defaultError)
//                }
//                
//            case .failure(let error) :
//                print("AlamofireManagerError : \(error.localizedDescription)")
//                failure(error)
//            }
//        }
//    }
//}
