//
//  ClientListViewController.swift
//  Check_Clients
//
//  Created by Станислав on 13.04.2022.
//

import RealmSwift
import UIKit

class ClientListViewController: UIViewController {
    
    // MARK: - Public Properties
    lazy var tableView = UITableView(frame: .zero, style: .plain)
    let searchController = UISearchController(searchResultsController: nil)
    var clients: Results<Client>!
    var filteredClients: Results<Client>!
    var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        // TODO: Не будет ли тут проблем с чтением из базы, когда база будет огромной
        // мб стоит использовать многопоточку
        clients = realm.objects(Client.self)
    }
    
    @objc func addClientButtonTapped() {
        let newClientViewController = NewClientViewController()
        let newClientNavigationController =  UINavigationController(
            rootViewController: newClientViewController)
        
        newClientViewController.delegate = self
        
        present(newClientNavigationController, animated: true)
    }
    
    func getSortedClients(from clientList: Results<Client>!) -> [(date: String, clients: [Client])] {
        ClientListDisplayDataParser.shared.getGroupedClients(from: clientList)
    }
    
    func getClient(from clientList: Results<Client>!, indexPath: IndexPath) -> Client {
        let sortedClients = getSortedClients(from: clientList)
        let client = sortedClients[indexPath.section].clients[indexPath.row]
        
        return client
    }
}
