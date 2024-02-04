//
//  SearchCityModel.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 03/02/24.
//

import Foundation

struct SearchCityModel: Codable {
    
    var country: String?
    var name: String?
    var lat: Double?
    var lon: Double?
    
    enum CodingKeys: String, CodingKey {
        case country
        case name
        case lat
        case lon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0
        self.lon = try container.decodeIfPresent(Double.self, forKey: .lon) ?? 0
    }

}
