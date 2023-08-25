//
//  LocationAuthProtocol.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/23.
//

import Foundation
import CoreLocation
protocol LocationAuthProtocol{
    var authSuccess:(()->Void)? {get set}
    var authFailed:(()->Void)? {get set}
    mutating func checkDeviceLocationAuthorization(success:@escaping ()->Void,failed:@escaping ()->Void)
    func checkDeviceLocationAuthorization()
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus)
}
extension LocationAuthProtocol{
    mutating func checkDeviceLocationAuthorization(success:@escaping ()->Void,failed:@escaping ()->Void){
        self.authFailed = failed
        self.authSuccess = success
        checkDeviceLocationAuthorization()
    }
}
