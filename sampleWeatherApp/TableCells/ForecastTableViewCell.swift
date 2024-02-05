//
//  weatherDetailsTableViewCell.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 01/02/24.
//

import UIKit
import Kingfisher

class ForecastTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func updateDataToCell(weatherListDetails: WeatherListDetails?) {
        dateLabel.text = weatherListDetails?.dt?.getDayofWeek()
        descriptionLabel.text = weatherListDetails?.weather?.last?.description?.camelized.uppercasingFirst
        temperatureLabel.text = weatherListDetails?.main?.temp?.getTemperatureString()
        weatherIconImageView.contentMode = .scaleAspectFit
        let urlString = weatherListDetails?.weather?.last?.icon ?? ""
        weatherIconImageView.kf.indicatorType = .activity
        weatherIconImageView.kf.setImage(with: urlString.getImageUrl())
    }

}
