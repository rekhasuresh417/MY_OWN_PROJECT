//
//  Resource.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.

import Foundation

public struct Resource<A, CustomError> {
    let path: Path
    let method: RequestMethod
    var headers: [String: String]
    var params: [String: Any]
    var groupOfParams: [[String: Any]]
    let parse: (Data) -> A?
    let parseError: (Data) -> CustomError?
    
    public init(path: String,
         method: RequestMethod = .get,
         params: [String: Any] = [:],
         groupOfParams: [[String: Any]] = [],
         headers: [String: String] = [:],
         parse: @escaping (Data) -> A?,
         parseError: @escaping (Data) -> CustomError?) {
        
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = headers
        self.parse = parse
        self.parseError = parseError
        self.groupOfParams = groupOfParams
    }
}

extension Resource where A: Decodable, CustomError: Decodable {
   public init(jsonDecoder: JSONDecoder,
         path: String,
         method: RequestMethod = .get,
         params: [String: Any] = [:],
         groupOfParams: [[String: Any]] = [],
         headers: [String: String] = [:]) {
        
        var newHeaders = headers
        newHeaders["Accept"] = "application/json"
        newHeaders["Content-Type"] = "application/json"
        
        self.path = Path(path)
        self.method = method
        self.params = params
        self.groupOfParams = groupOfParams
        self.headers = newHeaders
        self.parse = {
            try? jsonDecoder.decode(A.self, from: $0)
        }
        self.parseError = {
            try? jsonDecoder.decode(CustomError.self, from: $0)
        }
    }
}
