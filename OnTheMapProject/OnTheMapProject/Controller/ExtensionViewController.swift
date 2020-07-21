//
//  File.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Alert
    func showAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: buttons style
    func setUPButton(_ button: UIButton){
        button.layer.cornerRadius = 5
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.systemBlue
    }
    
    //MARK: logout
    func logout(){
        UdacityClient.deleteSession { (succes, error) in
            if succes{
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.showAlert(title: "Fail to lgout", message: error?.localizedDescription ?? "")
            }
        }
    }
    
}

