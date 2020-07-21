//
//  InformationPostingViewController.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    struct postedLocation{
        static var latitude: CLLocationDegrees?
        static var longitude: CLLocationDegrees?
        static var mapString: String?
        static var mediaUrl: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.text=""
        mediaURL.text=""
        location.delegate=self
        mediaURL.delegate=self
        setUPButton(findLocationButton)
    }
    
    //to dismiss the keyboard after press enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    //MARK: Gecoding
    @IBAction func findLocation(_ sender: Any) {
        if location.text=="" || mediaURL.text=="" {
            showAlert(title: "Faild", message: "all fields must be completed")
        }
        let gecoder = CLGeocoder()
        activityIndicator.startAnimating()
    
        gecoder.geocodeAddressString(location.text!) { (placemark, error) in
            self.activityIndicator.stopAnimating()
           
            if error != nil {
                self.showAlert(title: "Faild", message: "cannot find location with specified text")
            }
            else{
                let location = placemark?.first?.location
                postedLocation.latitude = location?.coordinate.latitude
                postedLocation.longitude = location?.coordinate.longitude
                postedLocation.mapString = self.location.text
                postedLocation.mediaUrl = self.mediaURL.text
                
                self.performSegue(withIdentifier: "postLocation", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postLocation" {
            let vc = segue.destination as! FinishPostingViewController
            vc.mapstring=postedLocation.mapString
            vc.mediaURL=postedLocation.mediaUrl
            vc.latitude=postedLocation.latitude
            vc.longitude=postedLocation.longitude
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
