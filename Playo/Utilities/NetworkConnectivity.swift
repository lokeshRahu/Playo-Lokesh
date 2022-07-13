//
//  NetworkConnectivity.swift
//  Playo
//
//  Created by yeshwanth srinivas rao bandaru on 13/07/22.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
struct errorConstants {
    static let Error = "Error"
    static let noData = "No Data"
    static let emptyCards = "No Cards Data received"
    static let urlToStringFail = "URL To String conversion Failed"
    static let noNetwork = "No Network"
    static let noNetworkDesc = "Please Check your Internet Connection and try again"
    
}
struct generalConstants {
    static let retry = "Retry"
    static let cancel = "Cancel"
    static let ok = "OK"
    static let list = "List"
}
