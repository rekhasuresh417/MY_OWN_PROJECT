//
//  ServiceError.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation

public enum WebError<CustomError>: Error {
    case noInternetConnection
    case custom(CustomError)
    case unauthorized
    case other
}
