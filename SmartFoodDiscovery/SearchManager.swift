//
//  SearchManager.swift
//  SmartFoodDiscovery
//
//  Created by Ashfaq ahmed on 09/09/25.
//

import Foundation
import MapKit
import Combine
import CoreLocation

class SearchManager: ObservableObject {
    @Published var results: [MKMapItem] = []
    
    func search(query: String, region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region  
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Search error:", error?.localizedDescription ?? "Unknown error")
                return
            }
            DispatchQueue.main.async {
                self.results = response.mapItems
            }
        }
    }
    
    func geocode(address: String, completion: @escaping (MKCoordinateRegion?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let loc = placemarks?.first?.location {
                let region = MKCoordinateRegion(
                    center: loc.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                completion(region)
            } else {
                completion(nil)
            }
        }
    }
}
