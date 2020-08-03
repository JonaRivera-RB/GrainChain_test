//
//  DetailRouteVC.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 29/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailRouteVC: UIViewController {
    
    //MARK: -Properties
    private let viewMap: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let mapView: GMSMapView = {
        let map = GMSMapView()
        map.layer.cornerRadius = 10
        map.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        return map
    }()
    
    private let distanceLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let timeOfRouteLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.setTitle("Share", for: .normal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var route: Route? {
        didSet {
            setupLabels()
        }
    }
    
    private var textToShare: String?
    private let database = Database()
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLabels()
        database.initDatabase()
        
        let removeRoute = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonTapped))
        navigationItem.rightBarButtonItems = [removeRoute]
    }
    
    func initRoute(route: Route) {
        self.route = route
    }
    
    //MARK: -Helpers
    @objc func deleteButtonTapped() {
        showAlert()
    }
    
    @objc func shareButtonTapped() {
        
        guard let textToShare = textToShare else { return }
        let text = [ textToShare ]
        let activityViewController = UIActivityViewController(activityItems: text, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: -Functions
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(viewMap)
        viewMap.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 200)
        
        viewMap.addSubview(mapView)
        mapView.anchor(top: viewMap.topAnchor, left: viewMap.leftAnchor, bottom: viewMap.bottomAnchor, right: viewMap.rightAnchor)
        
        let routeDetailStack = UIStackView(arrangedSubviews: [distanceLbl, timeOfRouteLbl])
        
        routeDetailStack.axis = .vertical
        routeDetailStack.distribution = .fillProportionally
        routeDetailStack.spacing = 4
        
        view.addSubview(routeDetailStack)
        routeDetailStack.anchor(top: viewMap.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(shareButton)
        shareButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20, width: 100, height: 50)
        shareButton.centerX(inView: self.view)
        
        shareButton.layer.cornerRadius = 50 / 2
    }
    
    private func removeRoute() {
        guard let routeId = route?.id else { return }
        database.deletePlace(idRoute: routeId) { success in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func setupLabels() {
        guard let route = route else { return }
        
        textToShare = "Hey! te quiero compartir mi ultimo recorrido!. \(route.km) en \(route.time)"
        distanceLbl.text = route.km + " recorridos c:"
        timeOfRouteLbl.text = route.time
        drawRoute(latitudes: route.latitude, longitudes: route.longitude)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "GranChain Route", message: "The route will be delete", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Sure", style: .destructive, handler: { alert in
            self.removeRoute()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { alert in }))
        
        self.present(alert, animated:true, completion: nil)
    }
    
    private func drawRoute(latitudes: String, longitudes: String) {
        var latitudes = latitudes.components(separatedBy: ",")
        var longitudes = longitudes.components(separatedBy: ",")
        
        latitudes.removeLast()
        longitudes.removeLast()
        
        var _coordinates = [Coordinates]()
        for (index, lat) in latitudes.enumerated() {
            _coordinates.append(Coordinates(latitude: Double(lat) ?? 0.0, longitude: Double(longitudes[index]) ?? 0.0))
        }
        
        let path = GMSMutablePath()
        for route in _coordinates {
            path.addLatitude(route.latitude, longitude: route.longitude)
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 10.0
        polyline.geodesic = true
        polyline.map = mapView
        
        guard let firstCoordinate = _coordinates.first else { return }
        guard let lastCoordinate = _coordinates.last else { return }
        drawMarkets(coordinates: firstCoordinate, title: "Started")
        drawMarkets(coordinates: lastCoordinate, title: "Finished")
        
        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: firstCoordinate.latitude, longitude: firstCoordinate.longitude), coordinate: CLLocationCoordinate2D(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude)))
        mapView.moveCamera(cameraUpdate)
        let currentZoom = mapView.camera.zoom
        mapView.animate(toZoom: currentZoom - 1.4)
    }
    
    func drawMarkets(coordinates: Coordinates, title: String) {
        let position = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
        let marker = GMSMarker(position: position)
        marker.title = title
        marker.map = mapView
    }
}
