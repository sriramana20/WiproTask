//
//  ServiceManager.swift
//  Exercise
//
//  Created by sriramana on 8/1/18.
//  Copyright © 2018 sriramana. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class ServiceManager: NSObject {
    
    static let sharedInstance: ServiceManager = { ServiceManager() }()
    
    func getDataFromService(url : String, success: @escaping (_ response: Any) -> Void, failure: @escaping (_ error: Error?) -> Void)  {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                print("returned error")
                failure(error)
                return
            }
            guard let content = data else {
                print("No data")
                failure(error)
                return
            }
            
            let string = String(data: content, encoding: String.Encoding.isoLatin1) as String!
            let encodedData = string?.data(using: String.Encoding.utf8, allowLossyConversion: false)
            do {
                let json = try JSONSerialization.jsonObject(with: encodedData!, options: []) as! [String: AnyObject]
                success(json)
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        })
        dataTask.resume()
    }
}
