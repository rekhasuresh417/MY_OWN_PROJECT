//
//  Path.swift
//  Itohen-dms
//
//  Created by PQC India iMac-2 on 27/11/22.

import Foundation

struct Path {
    public var components: [String]
    
    var absolutePath: String {
        return "/" + components.joined(separator: "/")
    }
    
   public init(_ path: String) {
        components = path.components(separatedBy: "/").filter({ !$0.isEmpty })
    }
    
    mutating func append(path: Path) {
        components += path.components
    }
    
    func appending(path: Path) -> Path {
        var copy = self
        copy.append(path: path)
        return copy
    }
}
