//
//  SearchCityViewModel.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 03/02/24.
//

import Foundation
import Alamofire

class SearchCityViewModel {
    
    var citiesList = [SearchCityModel]()
    var searchRequest : DataRequest? = nil
    
    //MARK: - City Search API

    func getCountryCoordinates(searchText: String, compeletion: @escaping AppUtils.WFCompletionHandler) {
        if AppUtils.inValidNetworkPreCondition(completionHandler: compeletion) {
            return
        }
        let parameters: Parameters = ["q": searchText,
                                      "limit": citiesSeacrhLimit,
                                      "appid": wetherAppId
        ]
        searchRequest?.cancel()
        searchRequest =  AF.request(geocodingUrl, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString))
            .responseData { response in
                switch response.result {
                    
                case .success(let json):
                    let statusCode = response.response?.statusCode
                    let jsonDecoder = JSONDecoder()
                    if statusCode == 200 {
                        if let cityDetails = try? jsonDecoder.decode([SearchCityModel].self, from: json) {
                            self.citiesList = cityDetails
                            compeletion(true, WFConstants.SuccessMessage.seacrhSuccess)
                            if !cityDetails.isEmpty { return }
                        }
                          compeletion(false, WFConstants.ErrorMessage.noRecordFound)
                    } else {
                        if let apiError = try? jsonDecoder.decode(ErrorModel.self, from: json), let message = apiError.message {
                            AppAlert.shared.showToast(message: message)
                            compeletion(false, message)
                        }
                    }
                case .failure(let error):
                    if !error.isExplicitlyCancelledError {
                        AppAlert.shared.showToast(message: error.localizedDescription)
                    }
                    break
                }
                
            }
        
    }
    
}
