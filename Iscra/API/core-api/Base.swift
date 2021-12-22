
//
//  Base.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 14/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

/// API Enviroment
public enum Environment {
    var APIVersion:String { return "" }
    var host: String {
        switch self {
        case .dev:
            return "http://3.21.113.243/api/v1/"
        case .staging:
            return "http://3.21.113.243/api/v1/"
        case .production:
            return "http://3.129.244.6/api/v1/"
        }
    }
    case staging
    case dev
    case production
}

let APIEnvironment: Environment = .production
typealias APIResult<T:Codable> = (_ result:T?, _ error:APIError?) -> Void

let imageBaseUrl = "https://nodevg82.elb.cisinlive.com/"
let placeHolder = UIImage(named: "defaultUser-Male")
let ownerPlaceHolder = UIImage(named: "usersIcon")

public enum HTTPSMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum Parameters {
    case none
    case body(data: Data?)
    case url(_: [String: String])
}

final class SessionDispatcher: NSObject, URLSessionDelegate {
    var headers: [String: String] = [:]
    let host: String
    var isMultipart = false
    let boundary = "Boundary-\(UUID().uuidString)"
//    var imageArray = [[String:Any]]()
    var imageArrayData = [Data]()
    var imageArrayName = [String]()
    var attachmentName = [String]()
    var multiPartData = Data()
    var apiRequest: RequestRepresentable!

    var session: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let s = URLSession(configuration: config)
        return s
    }
    
    func execute<T:Decodable>(requst: RequestRepresentable, modeling _: T.Type, completion:@escaping APIResult<T>) {
        
        switch requst.parameters {
        case let .body (data):
            if let obj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) {
                print("parameters of request",obj)
            }
        default:
            break
        }
        
        let  task = session.dataTask(with: prepareRequest(request: requst), completionHandler: { data, http, err in
            if err != nil { completion(nil, APIError(errorCode: .uknown, responseData: APIErroResponseData(message: err?.localizedDescription, error: err?.localizedDescription), statusCode: 0)) }
            guard let  resp = http as? HTTPURLResponse else {
                completion(nil, APIError(errorCode: .uknown, responseData: nil, statusCode: 0))
                return
            }
            
            guard let data = data else {
                completion(nil, APIError(errorCode: .uknown, responseData: nil, statusCode: resp.statusCode))
                return
            }
            if let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                print(obj)
            }
            self.handleReponse(data: data, response: resp, completion: completion)
        })
        task.resume()
    }
    
    func executeMultiPart<T:Decodable>(requst: RequestRepresentable, imageArrayData:[Data]?, imageArrayName:[String]?, attachmentName:[String]?, modeling _: T.Type, completion:@escaping APIResult<T>) {
        self.imageArrayData = imageArrayData ?? self.imageArrayData
        self.imageArrayName = imageArrayName ?? self.imageArrayName
        self.attachmentName = attachmentName ?? self.attachmentName
        self.isMultipart = true
        self.apiRequest = requst
        switch requst.parameters {
        case let .body (data):
            if let obj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) {
                self.multiPartData = data!
                print("parameters of request",obj)
            }
        default:
            break
        }
        
        let  task = session.dataTask(with: prepareRequest(request: requst), completionHandler: { data, http, err in
            if err != nil { completion(nil, APIError(errorCode: .uknown, responseData: nil, statusCode: 0)) }
            guard let  resp = http as? HTTPURLResponse else {
                completion(nil, APIError(errorCode: .uknown, responseData: nil, statusCode: 0))
                return
            }
            
            guard let data = data else {
                completion(nil, APIError(errorCode: .uknown, responseData: nil, statusCode: resp.statusCode))
                return
            }
            if let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                print(obj)
            }
            self.handleReponse(data: data, response: resp, completion: completion)
        })
        task.resume()
    }
    
    override init() {
        self.host = APIEnvironment.host
    }
    
    private func handleErrorMessage(errorCode: ErrorCode) -> String {
        switch errorCode {
        case .authorize:
            return AUTHORISATION_ERROR_MESSAGE
        case .badRequest:
            return BAD_REQUEST_ERROR_MESSAGE
        case .network:
            return NETWORK_ERROR_MESSAGE
        case .parsing:
            return PARSING_ERROR_MESSAGE
        case .server:
            return SERVER_ERROR_MESSAGE
        default:
            return ERROR_MESSAGE
        }
    }
    
    func handleReponse<T:Codable>(data:Data, response:HTTPURLResponse,completion:@escaping APIResult<T>) {
        print("received response status code:\(response.statusCode)")
        let (ok, code) = statusOK(response: response)
        if !ok {
            
          //  let error = APIError(errorCode: code, responseData: APIErroResponseData(message: handleErrorMessage(errorCode: code), error: handleErrorMessage(errorCode: code)), statusCode: response.statusCode) // old
            
            let error = APIError(errorCode: code, responseData: APIErroResponseData.from(data: data), statusCode: response.statusCode) // new to show backend message
            completion(nil, error)
            return
        }
        
        let (model, err) = Parser<T>.from(data)
        if err == nil {
            completion(model, nil)
            return
        }
        
        if let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            print(obj)
        }
        completion(nil, APIError(errorCode: .parsing, responseData: nil, statusCode: response.statusCode))
    }
    
    func statusOK(response:HTTPURLResponse)-> (Bool, ErrorCode) {
        
        var code:ErrorCode
        var ok:Bool
        switch response.statusCode {
        case 200,203,201:
            code = .uknown
            ok = true
        case 403:
            code = .authorize
            ok = false
        case 400:
            code = .badRequest
            ok = false
        case 500,502 :
            code = .server
            ok = false
        default:
            code  = .uknown
            ok = false
        }
        
        return (ok, code)
    }
    
    private func prepareRequest(request: RequestRepresentable) -> URLRequest {
      //  let s = "\(host)/\(APIEnvironment.APIVersion)\(request.endpoint)"
        let s = "\(host)\(APIEnvironment.APIVersion)\(request.endpoint)"
        let scaped = s.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: scaped!)
        var r = URLRequest(url: url!)
        headers(in: request, for: &r)
        params(in: request, for: &r)
        print("sending header:", headers)
        print("sending request:", s)
        return r
    }
    
    
    private func headers(in request: RequestRepresentable, for urlRequest: inout URLRequest) {
        urlRequest.httpMethod = request.method.rawValue
        addDefaultHeaders()
        headers.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: "\(key)")
        })
        request.headers?.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: "\(key)")
        })
    }
    
    private func addDefaultHeaders() {
        if UserStore.token != nil {
            headers["Authentication-Token"] = UserStore.token ?? ""
        }
//        headers["device_type"] = "ios"
//        headers["device_id"] = UIDevice.current.identifierForVendor?.uuidString
//        headers["current_time_zone"] = "IST"
//        headers["language"] = "en"
        headers["Content-Type"] = "application/json"
//        headers["current_country"] = "India"
//        headers["lat"] = "22.7177"
//        headers["lng"] = "75.8545"
    }
    
    private func params(in request: RequestRepresentable, for urlRequest: inout URLRequest) {
        switch request.parameters {
        case let .body(data):
            if !isMultipart {
                urlRequest.httpBody = data
            } else {
                urlRequest.httpBody = getMultipartData()
            }
            
        case let .url(urlencoded):
            var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)
            urlencoded.forEach { key, value in
                let query = URLQueryItem(name: key, value: value)
                urlComponents?.queryItems?.append(query)
            }
            urlRequest = URLRequest(url: (urlComponents?.url)!)
        case .none: break
        }
    }
    
    private func getMultipartData() -> Data {
        var data = Data()
        if let obj = try? JSONSerialization.jsonObject(with: self.multiPartData, options: .allowFragments) {
            for(key, value) in obj as! [String:Any] {
                // Add the reqtype field and its value to the raw http request data
                if key != "image" {
                    data.append("\r\n--\(boundary)\r\n")
                    data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    data.append("\(value)\r\n")
                }
            }
            
            for (index,imageData) in self.imageArrayData.enumerated() {
                // Add the image data to the raw http request data
                data.append("--\(boundary)\r\n")
                data.append("Content-Disposition: form-data; name=\"\(imageArrayName[index])\"; filename=\"\(imageArrayName[index])\"\r\n")
                data.append("Content-Type: image/jpeg\r\n\r\n")
                data.append(imageData)
                data.append("\r\n")
                data.append("--\(boundary)--\r\n")
            }
        }
        return data
    }
    
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}


