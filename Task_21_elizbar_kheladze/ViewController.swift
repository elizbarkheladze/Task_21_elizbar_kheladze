//
//  ViewController.swift
//  Task_21_elizbar_kheladze
//
//  Created by alta on 8/11/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UISearchBarDelegate{

    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(CountryTableViewCell.self,forCellReuseIdentifier: CountryTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private var countries = [Country]()
    private var viewModels = [CountryTableViewCellViewModel]()
    private var filteredCountries = [CountryTableViewCellViewModel]()
    private var filteredCountries1 = [Country]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        title = "COuntries"
        view.backgroundColor = .systemBackground
        
        createSearch()
        
        getCOuntries()
        
        
    }

    
    
    private func getCOuntries(){
        ApiCall.shared.getCountry { [weak self] result in
            switch result{
            case .success(let countries):
                self?.countries = countries
                self?.viewModels = countries.compactMap({
                    CountryTableViewCellViewModel(title: $0.name, imageurl: URL(string: $0.flags.png ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    private func createSearch(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCountries.isEmpty{
            return viewModels.count
        }else {
           return  filteredCountries.count
        }
         
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier,for: indexPath)as? CountryTableViewCell else{
            fatalError()
        }
        if filteredCountries.isEmpty{
            cell.configure(with: viewModels[indexPath.row])
        } else {
            cell.configure(with: filteredCountries[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var country = countries[0]
        if filteredCountries.isEmpty{
            country = countries[indexPath.row]
        }else {
            country = filteredCountries1[indexPath.row]
        }
        
        
       let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "CountryDetailsVC")as! CountryDetailsVC
        vc.countName = country.name
        vc.countpop = "\(country.population)"
        vc.countImg = country.flags.png
        navigationController?.pushViewController(vc, animated: true)
        
        
//        guard let url 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150  
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries =  viewModels.filter{$0.title.contains(searchText)}
        filteredCountries1 = countries.filter{$0.name.contains(searchText)}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

