//
//  Copyright 2017 Andrej Jurkin.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  CryptonatorProvider.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/22/17.
//


import Foundation
import Moya

enum CryptonatorProvider {
    
    case ticker(base: String, target: String)
}

extension CryptonatorProvider: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.cryptonator.com/api/")!
    }
    
    var path: String {
        switch self {
        case .ticker(let base, let target):
            return "ticker/\(base)-\(target)"
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
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
}
