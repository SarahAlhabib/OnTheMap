//
//  createSession.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import Foundation

struct CreateSessionResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable{
    let id: String
    let expiration: String
}
