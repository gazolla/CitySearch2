//
//  Destination.swift
//  PlacesToGo
//
//  Created by Sebastiao Gazolla Costa Junior on 26/03/2018.
//  Copyright © 2018 Sebastiao Gazolla Costa Junior. All rights reserved.
//

import Foundation
import MapKit

class Destination{
    var ident:String?
    var name:String?
    var administrativeArea:String?
    var country:String?
    var coordinates:CLLocationCoordinate2D?
    var region:CLRegion?
    var flagIconURL:String?

    init(ident:String?, name:String?, administrativeArea:String?, country:String?, coordinates:CLLocationCoordinate2D?, region:CLRegion?, flagIconURL:String?){
        self.ident = ident
        self.name = name
        self.administrativeArea = administrativeArea
        self.country = country
        self.coordinates = coordinates
        self.region = region
        self.flagIconURL = flagIconURL
    }
    
    init(){
        
    }

    convenience init(placemark:CLPlacemark){
        self.init()
        self.name = placemark.name
        self.administrativeArea = placemark.administrativeArea
        self.country = placemark.country
        self.coordinates = placemark.location?.coordinate
        self.region = placemark.region
        self.flagIconURL = placemark.isoCountryCode
    }
    
    convenience init(attrib:[String:AnyObject]){
        self.init()
        if let ident = attrib["id"] as? String { self.ident = ident }
        if let name = attrib["name"] as? String { self.name = name }
        if let location = attrib["location"]{
            if let state = location["state"] as? String { self.administrativeArea = state }
            if let country = location["country"] as? String { self.country = country }
          //  if let coordinates = placemark.location?.coordinate { self.coordinates = coordinates }
        }
    }

}
