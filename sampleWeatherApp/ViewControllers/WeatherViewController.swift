//
//  weatherViewController.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 31/01/24.
//

import UIKit
import CoreLocation

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
        weatherTableView.register(UINib(nibName: Identifiers.forecastHeaderCell, bundle: nil), forHeaderFooterViewReuseIdentifier: Identifiers.forecastHeaderCell)
        weatherTableView.setImageBackground()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifiers.forecastHeaderCell) as! ForecastHeaderCell
        headerView.contentView.backgroundColor = .clear
        let weatherDetails: WeatherListDetails? = weatherModel.groupedForecastList.first
        headerView.updateWeatherData(WeatherListDetails: weatherDetails, cityDetails: weatherModel.cityDetails)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        180
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        weatherModel.groupedForecastList.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherModel.groupedForecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecastCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.forecastListCell, for: indexPath) as? ForecastTableViewCell
        forecastCell?.contentView.backgroundColor = .clear
        let data = weatherModel.groupedForecastList[indexPath.row]
        forecastCell?.updateDataToCell(weatherListDetails: data)
        return forecastCell ?? UITableViewCell()
    }
    
}

extension WeatherViewController: RefreshDelegate {
    
    func selectedCity(model: SearchCityModel) {
        getCurrentLocationWeather(latitude: model.lat ?? 0, longtitude: model.lon ?? 0)
    }
    
}
