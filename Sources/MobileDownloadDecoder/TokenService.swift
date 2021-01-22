//
//  TokenBlob.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 8/19/20.
//

import Foundation
import MoneyAndExchangeRates

/// This handles a blob that's \t delimited and where each field is a token-character followed immediately by a value (compatible with the c# version called TokenBlob.cs)
class TokenService {
    let tokens: [Token]

    struct Token {
        let tokenType: String
        let stringValue: String

        var intValue: Int {
            Int(stringValue) ?? 0
        }

        var boolValue: Bool {
            intValue != 0
        }
        
        var money2Value: MoneyWithoutCurrency? {
            if let value = Int(stringValue) {
                return MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 2)
            }
            return nil
        }
        var money4Value: MoneyWithoutCurrency? {
            if let value = Int(stringValue) {
                return MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            }
            return nil
        }

        var decimal2Value: Decimal? {
            if let value = Int(stringValue) {
                return Decimal(value) / 100
            }
            return nil
        }

        var decimal4Value: Decimal? {
            if let value = Int(stringValue) {
                return Decimal(value) / 10000
            }
            return nil
        }

        var dateOrTimeValue: Date {
            Date.fromDownloadedDateOrDateTime(stringValue) ?? Date.distantPast
        }
    }

    init(_ rawFields: [String]) {
        let actualRawFields: [String]

        if rawFields[0] == "Nids" {
            actualRawFields = rawFields[1...].map { String($0) }.filter { !$0.isEmpty }
        } else {
            actualRawFields = rawFields.filter { !$0.isEmpty }
        }
        tokens = actualRawFields.map { Token(tokenType: String($0.prefix(1)), stringValue: String($0.dropFirst())) }
    }

    convenience init(_ blob: String) {
        if let decodedBlob = MobileDownloadDecoderService.decodeSafeMobileString(safeString: blob) {
            self.init(decodedBlob.components(separatedBy: "\t"))
        } else {
            self.init([])
        }
    }
}
