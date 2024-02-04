//
//  AppUtils.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 04/02/24.
//

import Foundation


class AppUtils: NSObject {
    
    public typealias WFCompletionHandler = (_ isSuccess: Bool, _ message: String) -> Void
    
    static let shared = AppUtils()

    //MARK: - Network Reachability Check

    public static func inValidNetworkPreCondition(completionHandler : WFCompletionHandler)-> Bool{
        if !NetworkReachability.shared.isConnected {
            AppAlert.shared.showToast(message: WFConstants.ErrorMessage.internetNotAvailable)
            completionHandler(false, WFConstants.ErrorMessage.internetNotAvailable)
            return true
        }
        return false
    }
   
    
}
