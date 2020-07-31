//
//  UserRoutesVC.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 29/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

private var reuseIdentifier = "RoutesCell"

class UserRoutesVC: UITableViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "My routes"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .singleLine
        
    }
}

//MARK: - UserRoutesVC
extension UserRoutesVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
