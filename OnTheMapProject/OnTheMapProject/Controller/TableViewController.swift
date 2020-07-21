//
//  TableViewController.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Students.studentsList.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        let student = Students.studentsList[indexPath.row]

        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.imageView?.image = UIImage(named: "location3")
        cell.detailTextLabel?.text=student.mediaURL

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Students.studentsList[indexPath.row]
        let url = URL(string: student.mediaURL)
        if let url = url , UIApplication.shared.canOpenURL(url){
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            showAlert(title: "Invalid URL", message: "cannot open this URL")
        }
        
    }
    
    //MARK: buttons
    
    @IBAction func logoutFromTableView(_ sender: Any) {
        logout()
    }
    
    @IBAction func pinLocation(_ sender: Any) {
        performSegue(withIdentifier: "InformationPostingTable", sender: nil)
    }
    @IBAction func updateData(_ sender: Any) {
        self.tableView.reloadData()
    }
}
