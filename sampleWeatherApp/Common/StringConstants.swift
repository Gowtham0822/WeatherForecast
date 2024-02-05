//
//  StringConstants.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 02/02/24.
//

import Foundation

//MARK: - String Constants
let weatherTitle = "Weather Forecast"
let wetherAppId = "bb00fc8ad7bdc358d3b6f608c7e3f10c"
let wetherMetricUnits = "metric"
let imageExtension = ".png"
let citiesSeacrhLimit = 5
let separator = ", "

//MARK: - Font Names
let fontHeavy = "SFUIDisplay-Heavy"
let fontBold = "SFUIDisplay-Bold"
let fontRegular = "SFUIDisplay-Regular"
let fontLight = "SFUIDisplay-Light"
let fontMedium = "SFUIDisplay-Medium"
let fontSemibold = "SFUIDisplay-Semibold"

//MARK: - Image String Constants
let weatherBackground = "cloudBackground"

//MARK: - Api URL
let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast"
let geocodingUrl = "https://api.openweathermap.org/geo/1.0/direct"
let imageBaseUrl = "https://openweathermap.org/img/w/"


//MARK: - String Success and Error Messages

public struct WFConstants {
    
    public init(){}

    public static var allowLocation = "Allow location from settings"
    public static var settingsTitle = "Settings"
    public static var cancelTitle = "cancel"
    public static var goTitle = "Go"
    public static var fetchWeather = "Fetching weather.."
    
    
    public struct ErrorMessage {
        
        private init(){}
        
        public static var internetNotAvailable = "Internet Not Available"
        public static var decodeError = "Something went wrong!"
        public static var locationError = "Make sure your location is enabled or search to check the weather."
        public static var noRecordFound = "No Record Found!"

    }
    
    public struct SuccessMessage {
        
        private init(){}
        
        public static var weatherSuccess = "Weather details fetch successfully"
        public static var seacrhSuccess = "City details fetch successfully"

        
    }
}
