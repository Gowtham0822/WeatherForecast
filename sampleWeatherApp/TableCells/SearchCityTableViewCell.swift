//
//  SearchCityTableViewCell.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 03/02/24.
//

import UIKit

class SearchCityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func updateData(searchedCity: SearchCityModel) {
        if let country = searchedCity.country, let city = searchedCity.name {
            cityNameLabel.text = city+separator+country
        } else {
            cityNameLabel.text = searchedCity.name ?? ""
        }
    }

}
