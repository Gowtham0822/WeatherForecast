//
//  HourlyForecastTableViewCell.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 04/02/24.
//

import UIKit

class HourlyForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
