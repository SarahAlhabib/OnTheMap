//
//  ParseClient.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 24/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import Foundation

class ParseClient{
    
    class func getStudentsLocations(completion: @escaping(Bool,Error?)->Void){
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    let error = ErrorResponse(status: 500, error: "couldn't load data")
                    completion(false,error)
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(LocationResult.self, from: data)
                Students.studentsList=response.results
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    let error = ErrorResponse(status: 500, error: "couldn't parse response data")
                    completion(false,error)
                }
                return
            }
        }
        task.resume()
    }
    
    class func postLocation(mapString:String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?)->Void){
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"uniqueKey\": \"\(UdacityClient.userKey)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                print(error!)
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(postLocationResponse.self, from: data)
                let newStudent = StudentInformation(createdAt: response.createdAt, firstName: "Jhon", lastName: "Doe", latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, objectId: response.objectId, uniqueKey: UdacityClient.userKey, updatedAt: "")
                Students.studentsList.insert(newStudent, at: 0)
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            
        }
        task.resume()
    }
}
