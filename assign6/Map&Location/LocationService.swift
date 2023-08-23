//
//  LocationService.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/23.
//

import Foundation
import CoreLocation
import Combine
enum LocationError:Error{
    case accessDenied
    case duplicateRequest
}
class LocationService:NSObject{
    static let shared = LocationService()
    private let locationManager = CLLocationManager()
    private var authSuccess:(()->Void)?
    private var authFailed:(()->Void)?
    public private(set) var isUpdating = false{
        didSet{
            if !isUpdating && oldValue != isUpdating{
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    public private(set) var isAvailableAccessLocation = false{
        didSet{
            if !isAvailableAccessLocation{self.isUpdating = false}
        }
    }
    private override init(){
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
    }
    var locationPassthrough = PassthroughSubject<Geo,Error>()
    func startUpdatingLocation(duration:Double? = nil,completion:(()->Void)? = nil) throws{
        guard isAvailableAccessLocation else { throw LocationError.accessDenied }
        guard !isUpdating else { throw LocationError.duplicateRequest}
        isUpdating = true
        print("로케이션 시작")
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        guard let duration else {return}
        DispatchQueue.global().asyncAfter(deadline: .now() + duration){
            if self.isUpdating{ self.isUpdating = false }
            completion?()
        }
    }
    func stopUpdatingLocation(){
        self.isUpdating = false
    }
}
//MARK: -- 유저 접근권한 확인 및 처리
extension LocationService{
    func checkDeviceLocationAuthorization(success:@escaping ()->Void,failed:@escaping ()->Void){
        self.authSuccess = success
        self.authFailed = failed
        checkDeviceLocationAuthorization()
    }
    private func checkDeviceLocationAuthorization(){
        // iOS 위치 서비스 활성화 체크
        DispatchQueue.global().async { [weak self] in
            guard let self else {return}
            if CLLocationManager.locationServicesEnabled(){
                var auth: CLAuthorizationStatus
                if #available(iOS 14.0, *){
                    auth = locationManager.authorizationStatus
                }else{
                    auth = CLLocationManager.authorizationStatus()
                }
                checkCurrentLocationAuthorization(status: auth)
            }else{
                print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못 합니다")
                self.authFailed?()
            }
        }
    }
    internal func checkCurrentLocationAuthorization(status: CLAuthorizationStatus){
        switch status{
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // Alert를 띄워주는 역할 -> 결정되지 않은 상태
        case .restricted: // 자녀 보호 기능으로 인해 위치 권한 박탈
            print("restricted")
        case .denied: // 그냥 거부
            print("denied")
            DispatchQueue.main.async {
                self.authFailed?()
            }
        case .authorizedAlways:
            print("authorizedAlways")
            isAvailableAccessLocation = true
            self.authSuccess?()
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            isAvailableAccessLocation = true
            self.authSuccess?()
        case .authorized:
            print("authorized")
            isAvailableAccessLocation = true
            self.authSuccess?()
        @unknown default:
            fatalError("이게 문어야")
        }
    }
}
extension LocationService: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationPassthrough.send(completion: .failure(error))
//        isUpdating = false
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            self.locationPassthrough.send((location.coordinate.latitude,location.coordinate.longitude))
        }
    }
}
