//
//  APIResponder.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 14/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import UIKit

protocol RequestRepresentable {
    var endpoint: String { get }
    var method: HTTPSMethod { get }
    var parameters: Parameters { get }
    var headers: [String: String]? { get }
}

extension RequestRepresentable {
    var headers:[String:String]? { return nil   }
    var method: HTTPSMethod         { return .post  }
    var parameters: Parameters   { return .none }
    
    func encodeBody<T: Codable>(data: T) -> Data? {
        let data = try? JSONEncoder().encode(data.self)
        return data
    }
    
    func encode(body:[String:Any]) ->Data? {
        return try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
    }
    
    func encode(body:Any) -> Data? {
        return try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
    }
}

public enum Response<T: Decodable> {
    case success(date: T)
    case failed(error: APIError)
}
