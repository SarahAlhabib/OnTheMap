//
//  ErrorResponse.swift
//  OnTheMapProject
//
//  Created by Sarah Alhabib on 23/11/1441 AH.
//  Copyright © 1441 Sarah Alhabib. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable{
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError{
    var errorDescription: String? {
        return error
    }
}
