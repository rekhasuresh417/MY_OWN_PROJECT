//
//  Languages.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import UIKit

// MARK: - DMSLanguagesResponse
class DMSLanguagesResponse: NSObject, Codable  {
    var status: String?
    var message: String?
    var status_code: Int?
    var data: [Languages]? = []
}

// MARK: - Languages
class Languages: NSObject, Codable {
    var id: Int?
    var name: String?
    var lang_code:String?
}
