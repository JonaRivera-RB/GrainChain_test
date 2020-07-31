//
//  MapVC.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 29/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import GoogleMaps

class MapVC: UIViewController {
    
    //MARK: -Properties
    var mapView = GMSMapView()
    var isTracking = false
    let locationManager = CLLocationManager()
    var mapViewModel = MapViewModel()
    var routes = [Coordenates]()
    var timer: Timer?
    var time = 0
    var locManager = LocationManager.shared
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: -life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.delegate = self
        
        setupGoogleMapInView()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locManager.stopTrackingGPS()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locManager.startTrackingGPS()
    }
    
    //MARK: -Selectors
    @objc func actionButtonTapped() {
        if locManager.isTracking {
            locManager.isTracking = false
            actionButton.setTitle("Start", for: .normal)
            setupActionButtonUI(forTitle: "Start", forColor: .systemBlue)
            alertWithTextfield()
            timer?.invalidate()
            guard let lastRoute = routes.last else { return }
            drawMarkets(coordinates: lastRoute, title: "Finish")
        }else {
            routes.removeAll()
            mapView.clear()
            locManager.isTracking = true
            startTime()
            setupActionButtonUI(forTitle: "Stop", forColor: .systemRed)
        }
    }
    
    //MARK: -Functions
    func alertWithTextfield() {
        let alert = UIAlertController(title: "GranChain Route", message: "Please input title for your route", preferredStyle: UIAlertController.Style.alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                self.mapViewModel.saveRouteInDatabase(routes: self.routes, forNameRoute: textField.text!, time: self.time)
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Route name"
            textField.textColor = .red
        }
        
        alert.addAction(save)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in })
        
        self.present(alert, animated:true, completion: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "My map"
        
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20, width: 100, height: 50)
        actionButton.centerX(inView: self.view)
        
        actionButton.layer.cornerRadius = 50 / 2
    }
    
    private func setupGoogleMapInView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        view.addSubview(mapView)
    }
    
    private func setupActionButtonUI(forTitle title: String, forColor color: UIColor) {
        actionButton.setTitle(title, for: .normal)
        actionButton.backgroundColor = color
    }
    
    func drawRoute(newLocation: CLLocationCoordinate2D) {
        routes.append(Coordenates(latitude: newLocation.latitude, longitude: newLocation.longitude))
        
        mapViewModel.setupLastLocation(lastLocation: newLocation)
        
        let path = GMSMutablePath()
        for route in routes {
            path.addLatitude(route.latitude, longitude: route.longitude)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 10.0
        polyline.geodesic = true
        polyline.map = mapView
        
        guard let firstLocation = routes.first else { return }
        drawMarkets(coordinates: firstLocation, title: "Start")
    }
    
    func drawMarkets(coordinates: Coordenates, title: String) {
        let position = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
        let marker = GMSMarker(position: position)
        marker.title = title
        marker.map = mapView
    }
    
    func startTime() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.time += 1
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension MapVC: LocationManagerChangesDelagate {
    func showUserLocationInMap(location: CLLocationCoordinate2D?) {
        guard let location = location else { return }
        mapView.isMyLocationEnabled = true
        
        setupCameraMap(location: location)
        
        mapViewModel.lastLocationSaved = location
    }
    
    func userLocationDidChanged(location: CLLocationCoordinate2D) {
        
        if let result = mapViewModel.verifyIfUserHasChangedLocation(lastLocation: location) {
            self.drawRoute(newLocation: result)
        }
        
        setupCameraMap(location: location)
    }
    
    private func setupCameraMap(location: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition(target: location, zoom: 15, bearing: 0, viewingAngle: 0)
        self.mapView.animate(to: camera)
    }
}
