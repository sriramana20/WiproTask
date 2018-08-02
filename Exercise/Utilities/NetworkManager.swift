//
//  NetworkManager.swift
//  Exercise
//
//  Created by sriramana on 8/2/18.
//  Copyright © 2018 sriramana. All rights reserved.
//

import ReachabilitySwift

class NetworkManager{
    
    static let sharedInstance: NetworkManager = { NetworkManager() }()

    func checkNetworkConnectivity() -> Bool {
        let reachabilityObj = Reachability()!
        var result : Bool = false
        if reachabilityObj.isReachable {
            if reachabilityObj.isReachableViaWiFi || reachabilityObj.isReachableViaWWAN{
                print("Reachable via WiFi")
                result = true
            }
        } else {
            result = false
            print("Network not reachable")
        }
        return result
    }
}

