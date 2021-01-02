//
//  LegacyDecoderService.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/18/20.
//

import Foundation
import MobileDownload

/// The MobileDownload files are encoded in avery tight proprietary (legacy) positional fashion
struct MobileDownloadDecoderService {
    static func decodeSafeMobileString(safeString: String) -> String? {
        if safeString.isEmpty {
            return nil
        }

        let backspace = Character("\u{8}")
        let tab = Character("\t")
        let carriageReturn = Character("\r")
        let newLine = Character("\n")
        let formFeed = Character("\u{C}")

        if let firstCharacter = safeString.first {
            if firstCharacter != backspace {
                return safeString
            }
        } else {
            return nil
        }

        var decoded: [Character] = []

        var isFirstCharacter = true
        var foundBackspace = false

        for char in safeString {
            if isFirstCharacter {
                if char != backspace {
                    return safeString
                }
                isFirstCharacter = false
                continue
            }
            if char == backspace {
                foundBackspace = true
                continue
            }
            if foundBackspace {
                foundBackspace = false

                switch char {
                case "t":
                    decoded.append(tab)
                case "n":
                    decoded.append(newLine)
                case "f":
                    decoded.append(formFeed)
                case "r":
                    decoded.append(carriageReturn)
                default:
                    decoded.append(char)
                }

                continue
            }

            decoded.append(char)
        }

        let result = String(decoded)

        return result
    }

    static func decodeRecNidSet(blob: String) -> [Int] {
        // see CommonTypes/RecNidSet.cs

        if blob.isEmpty {
            return []
        }

        var recNids: [Int] = []

        let ranges = blob.components(separatedBy: ",")

        for range in ranges {
            if range.hasPrefix("=") {
                _ = String(range.dropFirst(1)) // tableName (e.g. "=Companies" or "=Customers"
            } else {
                let lohi = range.components(separatedBy: "-")
                if var from = Int(lohi[0]),
                   let thru = lohi.count == 1 ? from : Int(lohi[1])
                {
                    while from <= thru {
                        recNids.append(from)
                        from += 1
                    }
                }
            }
        }

        return recNids
    }
}
