//
//  extentions.swift
//  Iscra
//
//  Created by Lokesh Patil on 13/10/21.
//

import Foundation
import UIKit


class Utils
{
    static func fetchDataFromLocalJson(name : String)-> NSDictionary? {
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return (jsonResult as! NSDictionary)
            } catch {
                // handle error
            }
        }
        return nil
    }
    
    static func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
}



