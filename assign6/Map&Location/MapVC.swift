//
//  MapVC.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/23.
//

import UIKit
import SnapKit
import Combine
import MapKit

class MapVC: UIViewController{
    let mapView = MKMapView()
    var subscription = Set<AnyCancellable>()
    let locationService = LocationService.shared
    let theaterModel = TheaterModel()
    var centerAnnotaion:MKPointAnnotation?
    var theaterAnnotations: [(TheaterItem,MKPointAnnotation)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mapView)
        locationService.checkDeviceLocationAuthorization {[weak self] in
            try? self?.locationService.startUpdatingLocation(duration: 3)
        } failed: {[weak self] in
            self?.showRequestLocationServiceAlert()
            self?.setCenterRegionAnnotation(geo: (37.5176,126.8864))
        }
        locationService.locationPassthrough.subscribe(on: DispatchQueue.main).sink { completion in
            switch completion{
            case .finished: print("finished")
            case .failure(let err): print(err)
            }
        } receiveValue: {[weak self] (latitude: Double, longtitude: Double) in
            self?.setCenterRegionAnnotation(geo: (latitude,longtitude))
        }.store(in: &subscription)

        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.navigationItem.rightBarButtonItem = .init(title: "Filter", style: .plain, target: self, action: #selector(Self.filterTapped(_:)))
    }
    @objc func filterTapped(_ sender: UIBarButtonItem){
        let alert = UIAlertController(title: "영화관을 선택하세요", message: nil, preferredStyle: .actionSheet)
        TheaterCompany.allCases.forEach { company in
            alert.addAction(.init(title: company.rawValue, style: .default){[weak self] _ in
                self?.setMarker(companies: [company])
            })
        }
        alert.addAction(.init(title:"전체보기",style:.default){[weak self] _ in
            self?.setMarker(companies: TheaterCompany.allCases)
        })
        alert.addAction(.init(title: "뒤로가기", style: .cancel))
        self.present(alert, animated: true)
    }
    @MainActor func setCenterRegionAnnotation(geo:(Double,Double)){
        let center = CLLocationCoordinate2D(latitude: geo.0, longitude: geo.1)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 400, longitudinalMeters: 400)
        let annotation = { // 애플이 기본 만들어 놓은 어노테이션
            let anno = MKPointAnnotation()
            anno.title = "중심이에용"
            anno.coordinate = center
            return anno
        }()
        if let centerAnnotaion{
            mapView.removeAnnotation(centerAnnotaion)
        }
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    func setMarker(companies:[TheaterCompany]){
        DispatchQueue.global().async {
            self.theaterModel.queryTheaters(companies: companies)
            var removeAnnos:[MKAnnotation] = []
            var appendAnnos:[MKAnnotation] = []
            // 없앨 아이템의 어노테이션은 removeAnnos 배열에 추가하고 안 없앨 것들은 아이템 정보만 남긴다.
            let filteredItems = self.theaterAnnotations.filter({ (item,anno) in
                if companies.contains(item.company){ return true
                }else{
                    removeAnnos.append(anno)
                    return false
                }
            }).map{$0.0}
            // 새로 받은 아이템 중 중복되지 않은 것만 남긴다.
            let needAppendAnnotationItems:Set<TheaterItem> = Set(self.theaterModel.theaterList).subtracting(filteredItems)
            // 새로운 아이템을 어노테이션과 저장할 배열과 appendAnnos 배열에 추가한다.
            let newTheaterAnnotations: [(TheaterItem,MKPointAnnotation)] = needAppendAnnotationItems.map { item in
                let annotation = { // 애플이 기본 만들어 놓은 어노테이션
                    let anno = MKPointAnnotation()
                    anno.title = item.locationName
                    anno.coordinate = .init(latitude: item.geo.latitude, longitude: item.geo.longtitude)
                    return anno
                }()
                appendAnnos.append(annotation)
                return (item,annotation)
            }
            DispatchQueue.main.async { // 여기에 나중에 뷰 애니메이션 추가하면 될 듯
                self.mapView.removeAnnotations(removeAnnos)
                self.mapView.addAnnotations(appendAnnos)
                self.theaterAnnotations.append(contentsOf: newTheaterAnnotations)
            }
        }
    }
}
extension MapVC:MKMapViewDelegate{
    @MainActor func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}
