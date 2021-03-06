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
        let csv: [String]
        
        init(_ string: String) {
            if string.hasPrefix("A") {
                let zzz = 1
            }
            if string.hasPrefix(",") {
                csv = string.dropFirst().components(separatedBy: ",")
                tokenType = "," + csv[0]
                stringValue = csv.count >= 2 ? csv[1] : ""
            } else {
                tokenType = String(string.prefix(1))
                stringValue = String(string.dropFirst())
                csv = stringValue.components(separatedBy: ",")
            }
        }

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

        if rawFields.count >= 1 && rawFields[0] == "Nids" {
            actualRawFields = rawFields[1...].map { String($0) }.filter { !$0.isEmpty }
        } else {
            actualRawFields = rawFields.filter { !$0.isEmpty }
        }
        tokens = actualRawFields.map { Token($0) }
    }

    convenience init(_ blob: String) {
        if let decodedBlob = MobileDownloadDecoderService.decodeSafeMobileString(safeString: blob) {
            self.init(decodedBlob.components(separatedBy: "\t"))
        } else {
            self.init([])
        }
    }
}
