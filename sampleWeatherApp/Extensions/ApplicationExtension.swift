//
//  ApplicationExtension.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 04/02/24.
//

import Foundation
import UIKit

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
        if #available(iOS 15.0, *) {
            let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = scenes?.windows.last
            return window
        } else {
            if let window = UIApplication.shared.windows.last {
                return window
            }
        }
    }
}
