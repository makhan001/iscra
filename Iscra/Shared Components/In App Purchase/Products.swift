//
//  Products.swift
//  Iscra
//
//  Created by m@k on 29/12/21.
//

import Foundation

public struct Products {
    public static let ads = "com.adilbek.iscra.removeads"
    public static let subscriptionMonth = "com.adilbek.iscra.1month"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [ Products.ads, Products.subscriptionMonth]
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
