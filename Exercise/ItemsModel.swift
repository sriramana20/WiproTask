//
//  ItemsModel.swift
//  Exercise
//
//  Created by sriramana on 8/1/18.
//  Copyright © 2018 sriramana. All rights reserved.
//

import Foundation
import ObjectMapper

class ItemsModel : BaseModel {
    
    var rows: [DataModel]?
    var title : String?
    
    override func mapping(map: Map) {
        rows <- map["rows"]
        title <- map["title"]
    }
}
