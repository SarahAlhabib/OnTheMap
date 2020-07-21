//
//  FinishPostingViewController.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit
import MapKit

class FinishPostingViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    
    var mapstring: String!
    var mediaURL: String!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPButton(finishButton)
        
        //MARK: map preparing
        mapView.delegate=self
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate=coordinates
        annotation.title=mapstring
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
        
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
    
    //MARK: Post new location to server
    @IBAction func finish(_ sender: Any) {
        ParseClient.postLocation(mapString: mapstring, mediaURL: mediaURL, latitude: latitude, longitude: longitude) { (success, error) in
            if success {
                
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                self.showAlert(title: "Faild", message: "Faild to pin new location")
            }
        }
    }
}
