//
//  HomeFeedViewModel.swift
//  Exercise
//
//  Created by sriramana on 8/2/18.
//  Copyright © 2018 sriramana. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON
import Alamofire
import ObjectMapper

protocol JsonFeedVMDelegate: class {
    func errorHandling(_ error:String)
    func getJSONFeedSuccessHandler(_ title : String, response: [DataModel])
}

protocol HomeFeedViewModeling {
    weak var delegate: JsonFeedVMDelegate? { get set }
}

class HomeFeedViewModel: HomeFeedViewModeling {
    
    weak var delegate: JsonFeedVMDelegate?
    let serviceManager = ServiceManager.sharedInstance
    var dataItems : [DataModel]  = [DataModel]()
    var title : String = ""

    func handleError(_ error:String){
        self.delegate?.errorHandling(error)
    }
    func getJsonFeed(){
        self.serviceManager.getDataFromService(success: {(response) -> Void in
            let json = JSON(response)
            if json != JSON.null {
                self.dataItems.removeAll()
                for i in 0..<json["rows"].count {
                    if let rawStr = json["rows"][i].rawString(),
                        let obj = Mapper<DataModel>().map(JSONString: rawStr){
                        self.dataItems.append(obj)
                    }
                }
                if let title =  json["title"].string{
                    self.title = title
                }
                self.delegate?.getJSONFeedSuccessHandler(self.title, response: self.dataItems)
            } else {
                self.handleError("Oops! Something's not right.")
            }
        }) {(error) -> Void in
            if let err  = error{
                print(err.localizedDescription)
                self.handleError(err.localizedDescription)
            }
        }
    }
}
