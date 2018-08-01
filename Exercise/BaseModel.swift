//
//  BaseModel.swift
//  Exercise
//
//  Created by sriramana on 8/1/18.
//  Copyright © 2018 sriramana. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel : Mappable {
    var base: String?
    
    required init?(map: Map) {
        
    }
    
    init(){
        
    }
    
    func mapping(map: Map) {
        base <- map["base"]
    }
}
