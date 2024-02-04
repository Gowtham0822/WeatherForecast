//
//  SearchCityViewController.swift
//  sampleWeatherApp
//
//  Created by Macbook Air on 02/02/24.
//

import UIKit

protocol RefreshDelegate {
    func selectedCity(model: SearchCityModel)
}

class SearchCityViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    let searchCityViewModel = SearchCityViewModel()
    var refreshData: RefreshDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupTableView()
    }
    
    //MARK: - TableView Setup

    func setupTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UINib(nibName: Identifiers.searchCityTableViewCell, bundle: nil), forHeaderFooterViewReuseIdentifier: Identifiers.searchCityTableViewCell)
       
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
    }

}

extension SearchCityViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchCityViewModel.citiesList.removeAll()
            self.reloadTableView()
        } else {
            searchCityViewModel.getCountryCoordinates(searchText: searchText) { isSucess, message in
                if isSucess {
                    self.searchTableView.removeBackground()
                    self.reloadTableView()
                } else {
                    self.searchTableView.setEmptyMessage(WFConstants.ErrorMessage.noRecordFound)
                }
            }
        }
    }
    
}

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchCityViewModel.citiesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityDetailsCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.searchCityTableViewCell, for: indexPath) as? SearchCityTableViewCell
        let data = searchCityViewModel.citiesList[indexPath.row]
        cityDetailsCell?.updateData(searchedCity: data)
        return cityDetailsCell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = searchCityViewModel.citiesList[indexPath.row]
        self.refreshData?.selectedCity(model: selectedModel)
        self.dismiss(animated: true)
    }
    
    
}
