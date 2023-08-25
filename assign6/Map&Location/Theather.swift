//
//  Theather.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/23.
//

import Foundation
typealias Geo = (latitude:Double,longtitude:Double)
enum TheaterCompany:String,CaseIterable{
    case lotte = "롯데시네마"
    case mega = "메가박스"
    case cgv = "CGV"
}
struct TheaterItem:Hashable{
    static func == (lhs: TheaterItem, rhs: TheaterItem) -> Bool {
        lhs.geo == rhs.geo && lhs.company == rhs.company
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(locationName)
        hasher.combine(company)
    }
    let company:TheaterCompany
    let locationName: String
    let geo: Geo
    init(item: MapResources.Theater){
        self.company = TheaterCompany(rawValue: item.type)!
        self.locationName = item.location
        self.geo = (item.latitude,item.longitude)
    }
}
class TheaterModel{
    private let theatersDict:[TheaterCompany:[TheaterItem]] = Dictionary(grouping: MapResources.TheaterList().mapAnnotations.map { TheaterItem(item: $0) }){
        val in val.company }
    public private(set) var theaterList: [TheaterItem] = []
    func queryTheaters(companies:[TheaterCompany]){
        theaterList = []
        companies.forEach { company in theaterList.append(contentsOf: theatersDict[company]!) }
    }
}
