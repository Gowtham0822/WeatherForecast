//
//  HourlyForecastCollectionViewCell.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 04/02/24.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    func updateData(model: WeatherListDetails) {
        timeLabel.text = model.dt?.timeStringFromUnixTime()
        iconImageView.contentMode = .scaleAspectFit
        let urlString = model.weather?.last?.icon ?? ""
        iconImageView.kf.indicatorType = .activity
        iconImageView.kf.setImage(with: urlString.getImageUrl())
        temperatureLabel.text = model.main?.temp?.getTemperatureString()
    }
    
}
