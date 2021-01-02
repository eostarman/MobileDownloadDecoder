import MobileDownload

//
//  EncodedFlags.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/26/20.
//

import Foundation

struct EncodedFlags {
    var flags: String.UnicodeScalarView.Iterator
    var flagsOffset = 0

    static let unicodeOne: UnicodeScalar = "1"
    static let unicodeSpace: UnicodeScalar = " "
    static let unicodeEmptyStringIterator = "".unicodeScalars.makeIterator()

    init(flags: String) {
        self.flags = flags.unicodeScalars.makeIterator()
    }

    mutating func getFlagCharacter(_ i: Int) -> UnicodeScalar {
        if i != flagsOffset {
            fatalError("Expected flag offset \(flagsOffset), not \(i)")
        }

        flagsOffset += 1
        return flags.next() ?? Self.unicodeSpace
    }

    mutating func getFlag(_ i: Int) -> Bool {
        if i != flagsOffset {
            fatalError("Expected flag offset \(flagsOffset), not \(i)")
        }

        flagsOffset += 1
        return flags.next() == Self.unicodeOne
    }
}
