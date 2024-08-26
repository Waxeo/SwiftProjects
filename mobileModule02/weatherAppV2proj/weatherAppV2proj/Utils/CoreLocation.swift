//
//  CoreLocation.swift
//  weatherAppV2proj
//
//  Created by Matteo Gauvrit on 14/08/2024.
//

import SwiftUI
import MapKit
import CoreLocationUI
import Foundation

// Classe pour la gestion de la géolocation (accepter la localisation + le lancer si validé)
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
        
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    // Ajouter une variable pour le statut de l'autorisation
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        // Initialiser le statut de l'autorisation
        self.authorizationStatus = locationManager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status  // Mettre à jour le statut de l'autorisation lorsque cela change
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        self.location = latestLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erreur lors de l'obtention de la localisation : \(error.localizedDescription)")
    }
}
