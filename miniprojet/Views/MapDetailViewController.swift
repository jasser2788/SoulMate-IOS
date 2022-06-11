//
//  MapDetailViewController.swift
//  miniprojet
//
//  Created by iMac on 17/5/2022.
//

import UIKit
import MapKit
import CoreLocation
class MapDetailViewController: UIViewController {

    @IBOutlet weak var mappView: MKMapView!
    var locationManager: CLLocationManager!
    let annotation1 = MKPointAnnotation()
    var maplatitude:Double = 0.0
    var maplongitude:Double = 0.0
    override func viewDidLoad() {
        
              super.viewDidLoad()
        mappView.delegate = self
       
        print (maplatitude)
              showPointsOfInterest()
              getDirections()
            
              annotation1.coordinate = CLLocationCoordinate2D(latitude:maplatitude, longitude: maplongitude)
              annotation1.title = "Example 0" // Optional
              annotation1.subtitle = "Example 0 subtitle" // Optional
              self.mappView.addAnnotation(annotation1)
              locationManager = CLLocationManager()
              locationManager.requestWhenInUseAuthorization()
              locationManager.delegate = self
              self.mappView.delegate = self
        //let annotations = MKPointAnnotation()

       // annotation1.title = "nn"
        
        



        //annotations.coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)



        

        //self.mapView.addAnnotation(annotations)



        }
 
   
   
    func getDirections() {
            let request = MKDirections.Request()
            // Source
            let sourcePlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:maplatitude, longitude: maplongitude))
            request.source = MKMapItem(placemark: sourcePlaceMark)
            // Destination
            let destPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:maplatitude,longitude: maplongitude))
            request.destination = MKMapItem(placemark: destPlaceMark)
            // Transport Types
            request.transportType = [.automobile, .walking]

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let response = response else {
                    print("Error: \(error?.localizedDescription ?? "No error specified").")
                    return
                }

                let route = response.routes[0]
                self.mappView.addOverlay(route.polyline)

                // …
            }
        }
    func showPointsOfInterest() {
           let searchRequest = MKLocalSearch.Request()
           // searchRequest.naturalLanguageQuery = "tesla chargers"
           searchRequest.pointOfInterestFilter = MKPointOfInterestFilter(including: [.bank, .atm]) // or you can use excluding
           searchRequest.region = mappView.region
           searchRequest.resultTypes = [.pointOfInterest, .address]

           let search = MKLocalSearch(request: searchRequest)
           search.start { response, error in
               guard let response = response else {
                   print("Error: \(error?.localizedDescription ?? "No error specified").")
                   return
               }
               // Create annotation for every map item
               for mapItem in response.mapItems {
                   let annotation = MKPointAnnotation()
                   annotation.coordinate = mapItem.placemark.coordinate

                   annotation.title = mapItem.name
                   annotation.subtitle = mapItem.phoneNumber

                   self.mappView.addAnnotation(annotation)
               }
               self.mappView.setRegion(response.boundingRegion, animated: true)
           }
       }
   }
    

extension MapDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If you're showing the user's location on the map, don't set any view
           if annotation is MKUserLocation { return nil }
               
           let id = MKMapViewDefaultAnnotationViewReuseIdentifier
               
           // Balloon Shape Pin (iOS 11 and above)
           if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView {
               // Customize only the 'Example 0' Pin
               if annotation.title == "Example 0" {
                   view.titleVisibility = .visible // Set Title to be always visible
                   view.subtitleVisibility = .visible // Set Subtitle to be always visible
                   view.markerTintColor = .yellow // Background color of the balloon shape pin
                   view.glyphImage = UIImage(systemName: "plus.viewfinder") // Change the image displayed on the pin (40x40 that will be sized down to 20x20 when is not tapped)
                   // view.glyphText = "!" // Text instead of image
                   view.glyphTintColor = .black // The color of the image if this is a icon
                   return view
               }
           }
               
           // Classic old Pin (iOS 10 and below)
           if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView {
               // Customize only the 'Example 0' Pin
               if annotation.title == "Example 0" {
                   view.animatesDrop = true // Animates the pin when shows up
                   view.pinTintColor = .yellow // The color of the head of the pin
                   view.canShowCallout = true // When you tap, it shows a bubble with the title and the subtitle
                   return view
               }
           }
                       
           return nil
    }
}
    

extension MapDetailViewController: CLLocationManagerDelegate {
    
    // iOS 14
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("Not determined")
            case .restricted:
                print("Restricted")
            case .denied:
                print("Denied")
            case .authorizedAlways:
                print("Authorized Always")
            case .authorizedWhenInUse:
                print("Authorized When in Use")
            @unknown default:
                print("Unknown status")
            }
        }
    }

    
    // iOS 13 and below
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("Authorized Always")
        case .authorizedWhenInUse:
            print("Authorized When in Use")
        @unknown default:
            print("Unknown status")
        }
    }
}


