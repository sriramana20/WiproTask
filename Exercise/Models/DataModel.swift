//
//  DataModel.swift
//  Exercise
//
//  Created by sriramana on 8/1/18.
//  Copyright © 2018 sriramana. All rights reserved.
//

import Foundation
import ObjectMapper

class DataModel : BaseModel {
    
    public var descriptionValue: String?
    public var title: String?
    public var imageHref: String?
    
    override func mapping(map: Map) {
        descriptionValue <- map["description"]
        title <- map["title"]
        imageHref <- map["imageHref"]
    }
}

