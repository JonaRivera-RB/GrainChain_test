//
//  UserRoutesVC.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 29/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import GoogleMaps

private var reuseIdentifier = "RoutesCell"

class UserRoutesVC: UITableViewController {
    
    //MARK: - Properties
    private let database = Database()
    private var routes: [Route] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        database.initDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        
        getMyRoutes()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "My routes"
        
        tableView.register(RouteCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .singleLine
    }
    
    private func getMyRoutes() {
        routes = database.listRoutes()
    }
}

//MARK: - UserRoutesVC
extension UserRoutesVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RouteCell
        cell.route = routes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = DetailRouteVC()
        controller.initRoute(route: routes[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
