//
//  LocationService.swift
//  SMB
//
//  Created by Mateusz Dylewski on 11/01/2023.
//
import SwiftUI
import MapKit
import Foundation

class LocationService : NSObject, ObservableObject, CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager?
    
    @Published
    var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    func checkIfLocationServiceIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            //TODO: SHOW ALERT
            print("Location service disabled")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .restricted:
                //TODO: SHOW ALERT
                print("location restricted")
            case .denied:
                //TODO: SHOW ALERT
                print("location denied")
            case .authorizedAlways, .authorizedWhenInUse:
            mapRegion = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
            @unknown default:
                break
        }
    }
    
    //runs every time you create locationmanager and on every authorization change
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}
