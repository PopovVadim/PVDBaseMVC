//
//  CLLocationCoordinate2DExtension.swift
//  PVDSwiftExtensions
//
//  Created by Вадим Попов on 9/25/17.
//

import Foundation
import CoreLocation

/**
 *
 *
 */
public extension CLLocationCoordinate2D {
    
    /**
     */
    func equalTo(another: CLLocationCoordinate2D, accuracy: Double = 0.0001) -> Bool {
        return abs(self.latitude - another.latitude) <= accuracy && abs(self.longitude - another.longitude) <= accuracy
    }
    
    /**
     */
    func distanceTo(another: CLLocationCoordinate2D) -> Double {
        // a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
        // c = 2 ⋅ atan2( √a, √(1−a) )
        // d = R ⋅ c
        // where    φ is latitude, λ is longitude, R is earth’s radius (mean radius = 6,371km);
        // note that angles need to be in radians to pass to trig functions!
        
        let R: Double = 6371000
        
        let φ1 = self.latitude.degreesToRadians
        let φ2 = another.latitude.degreesToRadians
        let Δφ = (another.latitude.degreesToRadians - self.latitude.degreesToRadians).degreesToRadians
        let Δλ = (another.longitude - self.longitude).degreesToRadians
        let a = pow(sin(Δφ / 2), 2) + cos(φ1) * cos(φ2) * pow(sin(Δλ / 2), 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let d = R * c
        
        return d
    }
    
    /**
     */
    func interpolate(to: CLLocationCoordinate2D, percent: Double) -> CLLocationCoordinate2D {
        let latitude: Double = self.latitude + percent * (to.latitude - self.latitude)
        let longitude: Double = self.longitude + percent * (to.longitude - self.longitude)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
