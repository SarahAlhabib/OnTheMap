//
//  MapViewController.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: map preparing
        mapView.delegate=self
        
        let locations = Students.studentsList
        
        var annotations = [MKPointAnnotation]()
        
        for student in locations {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
        
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
        let reuseId = "pin"
            
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
            
        return pinView
    }

        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let url = URL(string: (view.annotation?.subtitle! ?? ""))
            if let url = url , UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                showAlert(title: "Invalid URL", message: "cannot open this URL")
            }
        }
        }

    //MARK: buttons
    @IBAction func logoutFromMapTap(_ sender: Any) {
        logout()
    }
    
    @IBAction func pinLocation(_ sender: Any) {
        performSegue(withIdentifier: "InformationPostingMap", sender: nil)
    }
    
    //apdate the map with new posted location
    @IBAction func updateMap(_ sender: Any) {
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: Students.studentsList[0].latitude, longitude: Students.studentsList[0].longitude)
        annotation.coordinate=coordinates
        annotation.title="\(Students.studentsList[0].firstName) \(Students.studentsList[0].lastName)"
        annotation.subtitle=Students.studentsList[0].mapString
        mapView.addAnnotation(annotation)
    }
}
