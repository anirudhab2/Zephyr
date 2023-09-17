//
//  LocationManager.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    typealias LocationResult = Result<Location, LocationError>
    typealias LocationResultBlock = (LocationResult) -> Void

    private var locationResultBlock: LocationResultBlock?

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
}

// MARK: - Fetch Location
extension LocationManager {
    func fetchCurrentLocation(
        completion: @escaping LocationResultBlock
    ) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationResultBlock = completion
            // Location access granted, set location accuracy based on the authorizatioon
            switch locationManager.accuracyAuthorization {
            case .reducedAccuracy:
                locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            case .fullAccuracy:
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            @unknown default:
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            }
            locationManager.requestLocation()

        case .notDetermined:
            self.locationResultBlock = completion
            locationManager.requestWhenInUseAuthorization()

        case .denied:
            completion(.failure(.permissionNotGranted))

        case .restricted:
            completion(.failure(.locationAccessRestricted))
        @unknown default:
            Logger.error.log(message: "Unknown location authorization status", category: .location)
        }
    }
}

// MARK: - LocationManager + CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let locationResultBlock else {
            return
        }
        fetchCurrentLocation(completion: locationResultBlock)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let result: LocationResult
        defer {
            DispatchQueue.main.async { [weak self] in
                self?.locationResultBlock?(result)
            }
        }

        guard let currentLocation = locations.first else {
            result = .failure(.failed)
            Logger.error.log(message: "Failed to fetch location", category: .location)
            return
        }
        let location = Location(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude
        )
        Logger.debug.log(message: "Location updated: \(location)", category: .location)
        result = .success(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.error.log(message: "Failed to fetch location", category: .location)
        DispatchQueue.main.async { [weak self] in
            self?.locationResultBlock?(.failure(.failed))
        }
    }
}

// MARK: - LocationManager + LocationError
extension LocationManager {
    enum LocationError: Error {
        case permissionNotGranted
        case locationAccessRestricted
        case failed
    }
}
