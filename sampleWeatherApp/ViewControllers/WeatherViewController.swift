//
//  weatherViewController.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 31/01/24.
//

import UIKit
import CoreLocation

enum ForecastType: Int, CaseIterable {
    case hourly
    case daily
}

class WeatherViewController: UIViewController {
    
    let weatherModel = WeatherViewModel()
    let refreshControl = UIRefreshControl()
    var locationManager: CLLocationManager!

    @IBOutlet weak var weatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        initializeLocationManager()
    }
    
    //MARK: - Navigation Setup

    func setupNavigation() {
        self.navigationItem.title = weatherTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addTapped))
    }
    
    //MARK: - TableView Setup
    
    func setupTableView() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(UINib(nibName: Identifiers.hourlyForecastTableViewCell, bundle: nil), forCellReuseIdentifier: Identifiers.hourlyForecastTableViewCell)
        weatherTableView.register(UINib(nibName: Identifiers.forecastHeaderCell, bundle: nil), forHeaderFooterViewReuseIdentifier: Identifiers.forecastHeaderCell)
        weatherTableView.setImageBackground()
        refreshControl.attributedTitle = NSAttributedString(string: WFConstants.fetchWeather)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        weatherTableView.addSubview(refreshControl)
    }
    
    //MARK: - Location Manger Setup

    func initializeLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            } else {
                DispatchQueue.main.async {
                    self.weatherTableView.setEmptyMessage(WFConstants.ErrorMessage.locationError)
                }
            }
        }
    }
    
    //MARK: - Location Weather API
    
    func getCurrentLocationWeather(latitude: Double, longtitude: Double) {
        self.view.makeToastActivity(.center)
        weatherModel.getWeatherUsingLocation(latitude: latitude, longtitude: longtitude) { isSucess, message in
            self.weatherTableView.reloadData()
            self.refreshControl.endRefreshing()
            isSucess ? self.weatherTableView.setImageBackground() : self.weatherTableView.setEmptyMessage(WFConstants.ErrorMessage.locationError)
            self.view.hideToastActivity()
        }
    }
    
    //MARK: - Target Actions

    @objc func addTapped() {
        let storyboard = UIStoryboard(name: Identifiers.storyboardMain, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: Identifiers.searchCityViewController) as? SearchCityViewController {
            vc.refreshData = self
            self.present(vc, animated: true)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if let coordinates = weatherModel.cityDetails?.coord, let latitude =  coordinates.lat, let longtitude =  coordinates.lon {
            self.getCurrentLocationWeather(latitude: latitude, longtitude: longtitude)
        } else {
            refreshControl.endRefreshing()
        }
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.last?.coordinate as? CLLocationCoordinate2D {
            self.getCurrentLocationWeather(latitude: coordinates.latitude, longtitude: coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationdidFailWithError \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            self.weatherTableView.setEmptyMessage(WFConstants.ErrorMessage.locationError)
            enableLocationPermissionInSettings()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func enableLocationPermissionInSettings(){
        let alert = UIAlertController(title: WFConstants.settingsTitle, message: WFConstants.allowLocation, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: nil)
        if let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
            alert.addAction(UIAlertAction(title: WFConstants.goTitle, style: .default) { action in
                    UIApplication.shared.open(settings)
                })
         }
        alert.addAction(UIAlertAction(title: WFConstants.cancelTitle, style: .cancel) { action in
            self.dismiss(animated: true)
        })
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch ForecastType.allCases[section] {
        case .hourly:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifiers.forecastHeaderCell) as! ForecastHeaderCell
            headerView.contentView.backgroundColor = .clear
            let weatherDetails: WeatherListDetails? = weatherModel.groupedForecastList.first
            headerView.updateWeatherData(WeatherListDetails: weatherDetails, cityDetails: weatherModel.cityDetails)
            return headerView
        case .daily:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch ForecastType.allCases[section] {
        case .hourly:
            200
        case .daily:
            0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch ForecastType.allCases[indexPath.section] {
        case .hourly:
            return 120
        case .daily:
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        weatherModel.groupedForecastList.isEmpty ? 0 : ForecastType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch ForecastType.allCases[section] {
        case .hourly:
            return 1
        case .daily:
            return weatherModel.groupedForecastList.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch ForecastType.allCases[indexPath.section] {
        case .hourly:
            let forecastCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.hourlyForecastTableViewCell, for: indexPath) as? HourlyForecastTableViewCell
            forecastCell?.backgroundColor = .clear
            forecastCell?.hourlyCollectionView.backgroundColor = .clear
            forecastCell?.hourlyCollectionView.delegate = self
            forecastCell?.hourlyCollectionView.dataSource = self
            forecastCell?.hourlyCollectionView.register(UINib(nibName: Identifiers.hourlyForecastCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.hourlyForecastCollectionViewCell)
            return forecastCell ?? UITableViewCell()
        case .daily:
            let forecastCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.forecastListCell, for: indexPath) as? ForecastTableViewCell
            forecastCell?.contentView.backgroundColor = .clear
            let data = weatherModel.groupedForecastList[indexPath.row]
            forecastCell?.updateDataToCell(weatherListDetails: data)
            return forecastCell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? HourlyForecastTableViewCell {
            cell.hourlyCollectionView.reloadData()
        }
    }
    
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherModel.hourlyForecastList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let forecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.hourlyForecastCollectionViewCell, for: indexPath) as? HourlyForecastCollectionViewCell
        forecastCell?.backgroundColor = .clear
        forecastCell?.updateData(model: weatherModel.hourlyForecastList[indexPath.row])
        return forecastCell ?? UICollectionViewCell()
    }
    
    
    
}

extension WeatherViewController: RefreshDelegate {
    
    func selectedCity(model: SearchCityModel) {
        getCurrentLocationWeather(latitude: model.lat ?? 0, longtitude: model.lon ?? 0)
    }
    
}
