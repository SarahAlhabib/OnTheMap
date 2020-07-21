//
//  ViewController.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //MARK: SetUp
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPButton(loginButton)
        email.text=""
        password.text=""
        email.delegate=self
        password.delegate=self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    //to dismiss the keyboard after press enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    
    //MARK: login
    @IBAction func login(_ sender: Any) {
        UdacityClient.createSessionId(email: email.text ?? "", password: password.text ?? "") { (success, error) in
            if success{
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
            else{
                self.showAlert(title: "Login Failed", message: error?.localizedDescription ?? "error with login")
                }
        }
    }
    
    //MARK: SignUp
    @IBAction func signUp(_ sender: Any) {
        let url = URL(string: "https://auth.udacity.com/sign-up")
        if let url = url {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            self.showAlert(title: "Login Failed", message: "sign up link does not work")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "completeLogin" {
            ParseClient.getStudentsLocations { (success, error) in
                if !success {
                    self.showAlert(title: "Load data fail", message: error?.localizedDescription ?? "")
                }
            }
        }
    }
}

