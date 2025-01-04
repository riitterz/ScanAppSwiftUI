//
//  MapView.swift
//  ScanAppSwiftUI
//
//  Created by Macbook on 09/11/2024.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let location: MKMapItem
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let coordinete = location.placemark.coordinate
        let region = MKCoordinateRegion(center: coordinete, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinete
        annotation.title = location.name
        mapView.addAnnotation(annotation)
    }
}
