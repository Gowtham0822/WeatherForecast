//
//  weatherViewModel.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 31/01/24.
//

import Foundation
import Alamofire

class WeatherViewModel {
    
    
    var cityDetails: CityDetails?
    var groupedForecastList = [WeatherListDetails]()
    var hourlyForecastList = [WeatherListDetails]()
    
    init() {
        self.groupedForecastList.removeAll()
    }
    
    //MARK: - Weather details API
    
    func getWeatherUsingLocation(latitude: Double, longtitude: Double, compeletion: @escaping AppUtils.WFCompletionHandler) {
        if AppUtils.inValidNetworkPreCondition(completionHandler: compeletion) {
            return
        }
        
        let parameters: Parameters = ["lat": "\(latitude)",
                                      "lon" : "\(longtitude)",
                                      "units": wetherMetricUnits,
                                      "appid": wetherAppId
        ]
        
        AF.request(forecastUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
            .responseData { response in
                switch response.result {
                    
                case .success(let json):
                    do {
                        let statusCode = response.response?.statusCode
                        let jsonDecoder = JSONDecoder()
                        if statusCode == 200 {
                            let currentAPPDetails = try jsonDecoder.decode(WeatherModel.self, from: json)
                            if let array = currentAPPDetails.list, !array.isEmpty {
                                self.groupForecastByDate(array: array)
                                self.cityDetails = currentAPPDetails.city
                            }
                            compeletion(true, WFConstants.SuccessMessage.weatherSuccess)
                        } else {
                            if let apiError = try? jsonDecoder.decode(ErrorModel.self, from: json), let message = apiError.message {
                                AppAlert.shared.showToast(message: message)
                                compeletion(false, message)
                            }
                        }
                    } catch let error {
                        print("jsonerror => \(error)")
                        AppAlert.shared.showToast(message: WFConstants.ErrorMessage.decodeError)
                    }
                case .failure(let error):
                    AppAlert.shared.showToast(message: error.localizedDescription)
                }
                
            }
        
    }
    
    //MARK: - Grouping Weather Details
    
    func groupForecastByDate(array: [WeatherListDetails]) {
        
        let groupedMessages = Dictionary(grouping: array) { (element) -> String in
            return element.dt?.getDayofWeek() ?? ""
        }
        let sortedKeys = groupedMessages.values.sorted(by: {$0.last?.dt ?? 0 < $1.last?.dt ?? 0})
        groupedForecastList.removeAll()
        hourlyForecastList.removeAll()
        hourlyForecastList = sortedKeys.first ?? []
        sortedKeys.forEach { details in
            if let weatherDetail = details.first {
                groupedForecastList.append(weatherDetail)
            }
        }
    }
    
}
