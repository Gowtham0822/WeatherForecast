//
//  TableviewExtension.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 03/02/24.
//

import Foundation
import UIKit


extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width:  bounds.size.width, height: ( bounds.size.height/2)))
        messageLabel.text = message
        if #available(iOS 13.0, *) {
            messageLabel.textColor = .systemGray
        } else {
            messageLabel.textColor = .gray
        }
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        backgroundView = messageLabel
    }
    
    func setImageBackground() {
        backgroundView = UIImageView(image: UIImage(named: weatherBackground))
    }
    
    func removeBackground() {
        backgroundView = nil
    }
    
}

