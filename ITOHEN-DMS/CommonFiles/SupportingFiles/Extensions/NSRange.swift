//
//  NSRange.swift
//  IDAS iOS
//
//  Created by PQC India iMac-2 on 27/11/22.
//

import Foundation

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

