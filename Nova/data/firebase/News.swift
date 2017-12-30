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
//  News.swift
//  Nova
//
//  Created by Andrej Jurkin on 12/30/17.
//

import Foundation
import RealmSwift
import ObjectMapper

class News: RealmObject, Mappable {
    
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var subtitle: String = ""
    dynamic var link: String = ""
    dynamic var imageUrl: String = ""
    dynamic var buttonTitle: String = ""
    dynamic var hidden: Bool = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.title <- map["title"]
        self.subtitle <- map["subtitle"]
        self.link <- map["link"]
        self.imageUrl <- map["imageUrl"]
        self.buttonTitle <- map["buttonTitle"]
        self.hidden <- map["hidden"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
