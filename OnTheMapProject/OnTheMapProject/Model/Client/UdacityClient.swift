//
//  UdacityClient.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import Foundation

class UdacityClient{
    
    private static var sessionId = ""
    static var userKey = ""
    
    
    class func createSessionId(email: String, password: String, completion: @escaping (Bool,Error?)->Void ) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            let newData = data.subdata(in: 5..<data.count) /* subset response data! */
            do {
                let response = try JSONDecoder().decode(CreateSessionResponse.self, from: newData)
                sessionId=response.session.id
                userKey=response.account.key
                DispatchQueue.main.async {
                    completion(true,nil)
                }
            }
            catch {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(false,errorResponse)
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(false,error)
                    }
                    return }
            }
        }
        task.resume()
    }
    
    class func deleteSession(completion: @escaping (Bool,Error?)->Void){
        let url = URL(string: "https://onthemap-api.udacity.com/v1/session")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        //cookie
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        //session
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
                DispatchQueue.main.async {
                    let error = ErrorResponse(status: 500, error: "couldn't logout")
                    completion(false,error)
                }
                return
            }
            sessionId=""
            userKey=""
            DispatchQueue.main.async {
                completion(true,error)
            }
            
        }
        task.resume()
        
    }
}
