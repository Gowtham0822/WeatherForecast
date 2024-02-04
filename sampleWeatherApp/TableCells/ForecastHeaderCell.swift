//
//  ForecastHeaderCell.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 02/02/24.
//

import UIKit

class ForecastHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var todayDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateWeatherData(WeatherListDetails: WeatherListDetails?, cityDetails: CityDetails?) {
        cityNameLabel.text = cityDetails?.name
        let desc = WeatherListDetails?.weather?.first?.description
        descriptionLabel.text = desc?.camelized.uppercasingFirst
        let temperature = WeatherListDetails?.main?.temp
        temperatureLabel.text = temperature?.getTemperatureString()
        todayDescriptionLabel.text = "Today: Mostly \(desc ?? "") currently. The high today was forecast as \(temperature?.getTemperatureString() ?? "")."
    }
}
