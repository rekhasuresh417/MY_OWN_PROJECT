//
//  Countries.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 27/07/22.
//

import Foundation

// MARK: - DMSCountriesResponse
class DMSCountriesResponse: NSObject, Codable{
    var status: String = ""
    var status_code: Int = 0
    var data: [Countries] = []
}

// MARK: - Countries
class Countries: NSObject, Codable{
    var id: Int = 0
    var name: String = ""
}

