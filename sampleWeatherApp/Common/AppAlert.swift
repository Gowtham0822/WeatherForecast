//
//  AppAlert.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 04/02/24.
//

import Foundation
import UIKit

class AppAlert: NSObject {
    
    static let shared = AppAlert()

    func showToast(message : String) {
        UIApplication.shared.currentUIWindow()?.makeToast(message)
    }
    
}
