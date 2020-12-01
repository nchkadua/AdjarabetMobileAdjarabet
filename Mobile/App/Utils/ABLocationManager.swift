//
//  ABLocationManager.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation
import CoreLocation

class ABLocationManager: NSObject, CLLocationManagerDelegate {
    public static let sharedInstance = ABLocationManager()

    public var locationManager: CLLocationManager?
    public var lastLocation: CLLocation?

    private func initManager() {
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else { return }

        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.delegate = self
    }

    public func load() {
        initManager()
        locationManager?.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }

    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.lastLocation = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
