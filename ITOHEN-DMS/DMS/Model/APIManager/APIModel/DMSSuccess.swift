//
//  DMSSuccess.swift
//  ITOHEN-DMS
//
//  Created by PQC India iMac-2 on 27/07/22.
//

import Foundation

// MARK: - DMSSuccess
struct DMSSuccess: Codable {
    var status_code: Int?
    var message: String?
    var error: String?
    var errors: Errors?
}

// MARK: - Errors
struct Errors: Codable {
    var first_name: [String]?
    var email: [String]?
    var mobile_number: [String]?
    var mobile: [String]?
    var style_no: [String]?
    var total_quantity: [String]?
    var order_price: [String]?
    var contact_number: [String]?
    var contact_email: [String]?
    var factory_id: [String]?
    
}
