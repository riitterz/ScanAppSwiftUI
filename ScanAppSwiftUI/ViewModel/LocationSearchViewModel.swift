//
//  LocationSearchViewModel.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 09/11/2024.
//

import SwiftUI
import MapKit

class LocationSearchViewModel: ObservableObject {
    @Published var searchResults: [MKMapItem] = []
    
    func searchLocation(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                DispatchQueue.main.async {
                    self.searchResults = response.mapItems
                }
            }
        }
    }
}


