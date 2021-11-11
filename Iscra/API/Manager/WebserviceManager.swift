//
//  extentions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation
import Alamofire

enum ServiceType {
    
    case signUp
    case logIn
    
}

typealias ServiceRequestSuccessBlock  = (_ result:Any) -> Void
typealias ServiceRequestFailureBlock  = (_ failurError:NSError) -> Void
typealias ServiceRequestOfflineBlock  = (_ offline:NSError) -> Void


class WebserviceManager : NSObject {
    static var shared = WebserviceManager()
    weak var alamofireManager : AlamofireManager? = AlamofireManager.shared
    private override init() {
        super.init()
    }
    
    func sendRequest(serviceType : ServiceType,
                     params : [String : Any],
                     success: @escaping ServiceRequestSuccessBlock,
                     failure: @escaping ServiceRequestFailureBlock,
                     offline: @escaping ServiceRequestOfflineBlock){
        
        // Provision for custom tokens
        let accessToken = ""
        print("SERVICE TYPE IS - \(serviceType)")
        
        switch serviceType {
        
        case .signUp:
            signUp(accessToken: accessToken, serviceType: serviceType, params: params, success: success, failure: failure, offline: offline)
        
        case .logIn:
            logIn(accessToken: accessToken, serviceType: serviceType, params: params, success: success, failure: failure, offline: offline)
            
        }
    }
    
    private func signUp(accessToken : String, serviceType : ServiceType, params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let headers : [String : String] = getGenericHeaders()
        let url = Router.signUp(params).FinalUrl
        let httpHeaders = HTTPHeaders.init(headers)
        //
        // Returning a mock response
        //
        let signUpdata = Utils.fetchDataFromLocalJson(name: "SignUpMock") as! [String : Any]
        success(signUpdata)
        print("localJSON signUpdata \(signUpdata)")
        return;
        
        alamofireManager?.makeAPIRequest(urlRequest: url, parameters: params, methodType: .post, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
            success(response)
            
        }) { (error) in
            failure(error as NSError)
        }
    }
    
    private func logIn(accessToken : String, serviceType : ServiceType, params: [String : Any], success: @escaping ServiceRequestSuccessBlock, failure: @escaping ServiceRequestFailureBlock, offline: @escaping ServiceRequestOfflineBlock) {
        
        let headers : [String : String] = getGenericHeaders()
        let url = Router.logIn(params).FinalUrl
        let httpHeaders = HTTPHeaders.init(headers)
      
        let logInData = Utils.fetchDataFromLocalJson(name: "LogInMock") as! [String : Any]
        print("localJSON logInData \(logInData)")
        success(logInData)
        return;
        
        alamofireManager?.makeAPIRequest(urlRequest: url, parameters: params, methodType: .post, encodingType: URLEncoding.default, headers: httpHeaders, success: { (response) in
            success(response)
            
        }) { (error) in
            failure(error as NSError)
        }
    }
}



// MARK:- Utils Extensions
extension WebserviceManager {
    
    func getGenericHeaders() -> [String : String] {
        let headers : [String : String] = [ "x-rapidapi-host": APIConstants.ConfigUrls.rapidapiHost,
                                            "x-rapidapi-key": APIConstants.ConfigUrls.rapidapiKey]
        return headers
    }
}

