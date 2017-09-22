//
//  CryptoCompareProvider.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/22/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import Moya

enum CryptoCompareProvider {
    
    case priceMulti(fromSymbols: [String], toSymbols: [String])
}

extension CryptoCompareProvider: TargetType {
 
    var baseURL: URL {
        return URL(string: "https://min-api.cryptocompare.com/")!
    }
    
    var path: String {
        switch self {
        case .priceMulti:
            return "data/pricemulti"
        }
    }
        
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .priceMulti(let fromSymbols, let toSymbols):

            return [
                "fsyms": toArrayParam(data: fromSymbols),
                "tsyms": toArrayParam(data: toSymbols)
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
    
    /// Workaround for CryptoCompare api, it does not accept a standard notation
    func toArrayParam(data: [String]) -> String {
        return data.joined(separator: ",")
    }
}
