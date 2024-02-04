//
//  ErrorModel.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 04/02/24.
//

import Foundation


struct ErrorModel: Codable {
    
    let cod: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case cod
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cod = try container.decodeIfPresent(Int.self, forKey: .cod) ?? 0
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
       
    }
}
