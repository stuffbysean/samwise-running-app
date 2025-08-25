import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var totalDistance: Double = 0.0
    @Published var isTracking = false
    @Published var currentSpeed: Double = 0.0
    @Published var currentPace: TimeInterval = 0.0
    @Published var altitude: Double = 0.0
    
    private var lastLocation: CLLocation?
    private var startTime: Date?
    private var locations: [CLLocation] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let minimumAccuracy: CLLocationAccuracy = 65.0
    private let minimumDistance: CLLocationDistance = 3.0
    
    override init() {
        super.init()
        setupLocationManager()
        authorizationStatus = locationManager.authorizationStatus
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = minimumDistance
        
        if #available(iOS 14.0, *) {
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        }
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = false
        }
    }
    
    func requestPermission() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Location access denied. User needs to enable in Settings.")
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            print("Already have always authorization")
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startTracking() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestPermission()
            return
        }
        
        reset()
        
        isTracking = true
        startTime = Date()
        
        if #available(iOS 9.0, *) {
            if authorizationStatus == .authorizedAlways {
                locationManager.allowsBackgroundLocationUpdates = true
            }
        }
        
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func stopTracking() {
        isTracking = false
        
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = false
        }
    }
    
    func reset() {
        totalDistance = 0.0
        currentSpeed = 0.0
        currentPace = 0.0
        altitude = 0.0
        lastLocation = nil
        startTime = nil
        locations.removeAll()
    }
    
    private func updatePace() {
        guard let startTime = startTime, totalDistance > 0 else {
            currentPace = 0.0
            return
        }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        currentPace = elapsedTime / totalDistance * 1000
    }
    
    func getCurrentPace() -> String {
        guard currentPace > 0 else { return "--:--" }
        
        let minutes = Int(currentPace) / 60
        let seconds = Int(currentPace) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func getAveragePace() -> String {
        guard let startTime = startTime, totalDistance > 0 else { return "--:--" }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        let averagePace = elapsedTime / totalDistance * 1000
        
        let minutes = Int(averagePace) / 60
        let seconds = Int(averagePace) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func getElevationGain() -> Double {
        guard locations.count > 1 else { return 0.0 }
        
        var gain: Double = 0.0
        for i in 1..<locations.count {
            let altitudeDifference = locations[i].altitude - locations[i-1].altitude
            if altitudeDifference > 0 {
                gain += altitudeDifference
            }
        }
        return gain
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last,
              newLocation.horizontalAccuracy < minimumAccuracy,
              newLocation.horizontalAccuracy > 0 else {
            return
        }
        
        location = newLocation
        self.locations.append(newLocation)
        
        currentSpeed = max(0, newLocation.speed * 3.6)
        altitude = newLocation.altitude
        
        if let lastLocation = lastLocation {
            let distance = newLocation.distance(from: lastLocation)
            
            if distance >= minimumDistance {
                totalDistance += distance
                updatePace()
            }
        }
        
        lastLocation = newLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        
        switch status {
        case .authorizedWhenInUse:
            if isTracking {
                manager.startUpdatingLocation()
            }
        case .authorizedAlways:
            if isTracking {
                manager.startUpdatingLocation()
                if #available(iOS 9.0, *) {
                    manager.allowsBackgroundLocationUpdates = true
                }
            }
        case .denied, .restricted:
            stopTracking()
            print("Location access denied or restricted")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                print("Location is currently unknown, but Core Location will keep trying")
            case .denied:
                print("Location services are disabled")
                DispatchQueue.main.async {
                    self.stopTracking()
                }
            default:
                print("Other location error: \(clError.localizedDescription)")
            }
        }
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("Location updates paused")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("Location updates resumed")
    }
}