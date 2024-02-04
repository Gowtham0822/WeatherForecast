//
//  weatherModel.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 31/01/24.
//

import Foundation


struct WeatherModel: Codable {
    
    var list: [WeatherListDetails]?
    var city: CityDetails?
    
    enum CodingKeys: String, CodingKey {
        case list
        case city
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.list = try container.decodeIfPresent([WeatherListDetails].self, forKey: .list) ?? []
        self.city = try container.decodeIfPresent(CityDetails.self, forKey: .city) ?? nil

    }
}

struct CityDetails: Codable {
    
    var name: String?
    var coord: CoordinatesDetails?
    
    enum CodingKeys: String, CodingKey {
        case name
        case coord
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.coord = try container.decodeIfPresent(CoordinatesDetails.self, forKey: .coord) ?? nil
    }
}

struct CoordinatesDetails: Codable {
    
    var lat: Double?
    var lon: Double?
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0
        self.lon = try container.decodeIfPresent(Double.self, forKey: .lon) ?? 0
    }
    
}

struct WeatherListDetails : Codable, Equatable {
    
    
    var weather: [WeatherDetails]?
    var main: TemperatureDetails?
    var dt: Double?

    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case dt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weather = try container.decodeIfPresent([WeatherDetails].self, forKey: .weather) ?? nil
        self.main = try container.decodeIfPresent(TemperatureDetails.self, forKey: .main) ?? nil
        self.dt = try container.decodeIfPresent(Double.self, forKey: .dt) ?? 0
    }
    
    static func == (lhs: WeatherListDetails, rhs: WeatherListDetails) -> Bool {
        lhs.dt != rhs.dt
    }
}

struct WeatherDetails: Codable {
    var description: String?
    var icon: String?
    var main: String?
    
    enum CodingKeys: String, CodingKey {
        case description
        case icon
        case main
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon) ?? ""
        self.main = try container.decodeIfPresent(String.self, forKey: .main) ?? ""
    }
}

struct TemperatureDetails: Codable {
    var temp: Double?
    var feels_like: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feels_like
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decodeIfPresent(Double.self, forKey: .temp) ?? 0
        self.feels_like = try container.decodeIfPresent(Double.self, forKey: .feels_like) ?? 0
    }
}
