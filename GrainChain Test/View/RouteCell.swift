//
//  RouteCell.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 31/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {
    //MARK: - Properties
    
    var route: Route? {
        didSet {
            configure()
        }
    }
    
    private let routeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Route name"
        label.textColor = .black
        return label
    }()
    
    private let kmLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "km"
        label.textColor = .black
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [routeNameLabel, kmLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let route = route else { return }
        
        routeNameLabel.text = route.name
        kmLabel.text = route.km
    }
}
