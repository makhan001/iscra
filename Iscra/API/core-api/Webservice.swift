//
//  Webservice.swift
//  Clustry
//
//  Created by m@k on 21/01/20.
//  Copyright © 2020 cis. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
//import SwiftyJSON

class WebService {
    typealias JSONTaskCompletionHandler = (Decodable?, String?) -> Void
    typealias JSONTaskCompletionHandlers = (NSDictionary?, String?) -> Void
    
    var headers: HTTPHeaders!
    
    func requestMultiPart<T: Decodable, U: Encodable>(urlString: String, httpMethod : HTTPMethod, parameters: U, decodingType: T.Type, imageArray: [[String : Any]], fileArray:[[String:Any]], file: [String:Any]? = nil, completion: @escaping JSONTaskCompletionHandler ) {
        
//        if Connectivity.isConnectedToInternet() != true {
//            completion(nil, NetworkErrorMessage)
//            return
//        }
        WebService().StartIndicator()
        
        let jsonData = try! JSONEncoder().encode(parameters)
        let jsonString = String(data: jsonData, encoding: .utf8)
        print("jsonString: \(String(describing: jsonString))")
        
        let s = "\(APIEnvironment.host)\(urlString)"
        print("Requesting url == \(s)")
        let scaped = s.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: scaped!)
        headers = addDefaultHeaders()
        headers["Content-Type"] = "multipart/form-data"
        let dict : [String : Any] = convertToDictionary(text: jsonString!)!
        print(dict)
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in dict {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            self.manageMultipartAssets(multipartFormData: multipartFormData, file: file)
        },to: url!, usingThreshold: UInt64.init(),
        method: httpMethod,
        headers: headers).response { encodingResult in
            switch encodingResult.result {
            case .success(let result):
                WebService().StopIndicator()
                if let data = result {
                    do {
                        // make sure this JSON is in the format we expect
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("json response is : \(json)")
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                    
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        print("response ---> \(genericModel)")
                        completion(genericModel, nil)
                    } catch let err {
                        print("error localizedDescription ---> \(err.localizedDescription)")
                        completion(nil, err.localizedDescription)
                    }
                } else {
                    completion(nil, encodingResult.error?.localizedDescription)
                }
                
            case .failure(let error):
                WebService().StopIndicator()
                print("upload err: \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func addDefaultHeaders() -> HTTPHeaders {
        let header: HTTPHeaders = [
            "Authentication-Token": UserStore.token ?? "",
            "Content-Type": "application/json; charset=UTF-8",
//            "device_type" : "ios",
//            "device_id" : "12345",
//            "current_time_zone" : "IST",
//            "language" :"en",
//            "Content-Type": "application/json",
//            "version" : "1.0.0",
//            "current_country": "India",
//            "lat": "22.12541",
//            "lng": "22.12541"
        ]
        return header
    }
    
    func request(urlStr: String, parameters:[String: AnyObject], httpMethod : HTTPMethod, completion: @escaping JSONTaskCompletionHandlers) {
        
        guard let url = URL(string: urlStr) else { return }
        AF.session.configuration.timeoutIntervalForRequest = 60
        var request = URLRequest.init(url: url)
        let requestData = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = requestData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Request start time----> \(Date())")
        print("API Request----\(request)")
        
        if NetworkReachabilityManager()?.isReachable == true {
            AF.request(request).responseJSON { response in
                print("Request end time----> \(Date())")
                let JSON = response.result
                print("Response---->\(JSON)")
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(nil, "Invalid data")
                        return
                    }
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            completion(jsonResponse, nil)
                        } else {
                            completion(nil, "Invalid response")
                        }
                    } catch let err {
                        print("Error\(err)")
                        completion(nil, err.localizedDescription)
                    }
                case .failure(let error):
                    print("Error\(error)")
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    private func manageMultipartAssets(multipartFormData: MultipartFormData, file:[String:Any]?) {
        if file != nil {
            let keys = file?.keys
            for key in keys! {
                if (file!["\(key)"] as? UIImage) != nil {
                    if let imageData = (file!["\(key)"] as! UIImage).jpegData(compressionQuality: 0.5) {
                        print("\(key)--\(imageData)")
                        multipartFormData.append(imageData, withName: "\(key)",fileName: "file.jpg", mimeType: "image/jpeg")
                    }
                }
                
                if let imagess  = file!["\(key)"] as? Data {
                    print("\(key)--\(imagess)")
                    multipartFormData.append(imagess, withName: "\(key)",fileName: "file.mov", mimeType: "video/*")
                }
                
                for key in keys! {
                    if let imagess  = file!["\(key)"] as? [UIImage] {
                        for img in imagess {
                            if let imageData = img.jpegData(compressionQuality: 0.5) {
                                print("\(key)--\(imageData)")
                                multipartFormData.append(imageData, withName: "\(key)",fileName: "file.jpg", mimeType: "image/jpeg")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func StartIndicator(){
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.show()
    }
    
    func StopIndicator(){
        UIApplication.shared.endIgnoringInteractionEvents()
        SVProgressHUD.dismiss()
    }
}
