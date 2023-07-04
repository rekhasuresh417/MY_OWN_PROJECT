//
//  Result.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation

public enum Result<A, CustomError, HTTPURLResponse> {
    case success(A)
    case failure(WebError<CustomError>)
    case status(HTTPURLResponse) // HTTPURLResponse
}

extension Result {
   public init(value: A?, or error: WebError<CustomError>, status:HTTPURLResponse) {
        guard let value = value else {
            self = .failure(error)
            self = .status(status)
            return
        }
        
        self = .success(value)
    
    }
    
   public var value: A? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
  public var error: WebError<CustomError>? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
    
   public var statusResponse: HTTPURLResponse?{
        guard case let .status(status) = self else { return nil }
        return status
    }
}
