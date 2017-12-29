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
//  FirebaseProvider.swift
//  Nova
//
//  Created by Andrej Jurkin on 12/29/17.
//

import Foundation
import Moya

enum FirebaseProvider {
    
    case news
}

extension FirebaseProvider: TargetType {
    var baseURL: URL {
        return C.firebaseBaseUrl
    }
    
    var path: String {
        switch self {
        case .news:
            return "/news.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        return .request
    }
    
    var sampleData: Data {
        return Data()
    }
}
