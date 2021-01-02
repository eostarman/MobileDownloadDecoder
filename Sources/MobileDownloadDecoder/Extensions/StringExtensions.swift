import MobileDownload

//
//  ArrayExtensions.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/13/20.
//

import Foundation

extension String {
    /// Convert a delimited string to an array of non-zero RecNids (blank and zero entries are ignored)
    func asRecNids(separatedBy: Character) -> [Int] {
        if isEmpty {
            return []
        }

        var recNids = [Int]()

        var n = 0

        for chr in self {
            if let digit = chr.wholeNumberValue {
                n = n * 10 + digit
            } else {
                if chr == separatedBy {
                    if n > 0 {
                        recNids.append(n)
                        n = 0
                    }
                } else {
                    n = 0
                }
            }
        }

        return recNids
    }

    /// Convert the string to a RecNid (a "record's numeric ID") - this is a nullable int (null when zero)
    /// - Returns: The integer recNid (or null)
    var asRecNid: Int? {
        if let recNid = Int(self), recNid > 0 {
            return recNid
        }
        return nil
    }

    /// Get the array of strings that are separated by a delimiter - actually, that are *terminated* by the deilmiter. So, a string like "1,2," will return ["1", "2"] without the final empty entry
    func asArrayWithoutFinalEmptyEntry(separatedBy: String) -> [String] {
        if isEmpty {
            return []
        }
        var entries = components(separatedBy: separatedBy)
        if let last = entries.last, last.isEmpty {
            entries.removeLast()
        }
        return entries
    }

    init?(fromLines lines: String ...) {
        var string = ""

        for index in stride(from: lines.count - 1, through: 0, by: -1) {
            if !lines[index].isEmpty {
                string = lines[0 ... index].joined(separator: "\n")
                break
            }
        }
        if string.isEmpty {
            return nil
        } else {
            self.init(string)
        }
    }
}
