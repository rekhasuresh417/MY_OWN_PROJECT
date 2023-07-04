//
//  DMSError.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.

import Foundation

// MARK: - DMSError
class DMSError: NSObject, Error, Decodable {
    var status: String?
    var status_code: Int?
    var message: String?
    var data: NoData?
    var error: String?
}

// MARK: - NoData
struct NoData: Codable {
    
}
