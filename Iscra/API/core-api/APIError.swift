
//
//  APIError.swift
//  Clustry
//
//  Created by Mohd Ali Khan on 14/11/2019.
//  Copyright © 2021 m@k. All rights reserved.
//

import UIKit

struct APIErroResponseData:Codable {
    let message:String?
    let error:String?
    static func from(data:Data) -> APIErroResponseData? {
        return try? JSONDecoder().decode(APIErroResponseData.self, from: data)
    }
}

public struct APIError:Error {
    let errorCode:ErrorCode
    var responseData:APIErroResponseData?
    var statusCode:Int
}

public enum ErrorCode {
    case badRequest
    case uknown
    case network
    case server
    case authorize
    case parsing
}
