//
//  DoubleExtension.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 01/02/24.
//

import Foundation

extension Double {
    
    func getDayofWeek() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    func getTemperatureString() -> String {
        let measurementFormatter = MeasurementFormatter()
        let temperature = Measurement(value: self, unit: UnitTemperature.celsius)
        measurementFormatter.locale = .current
        return measurementFormatter.string(from: temperature)
    }
    
}
