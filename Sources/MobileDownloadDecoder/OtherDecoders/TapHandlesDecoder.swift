//
//  TapHandlesDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/23/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct TapHandlesDecoder {
    static func decodeTapHandles(tapHandlesSection: [[String]]) -> TapHandles {
        var tapHandlesByLocation: [Int: [TapHandles.TapHandleAtLocation]] = [:]

        for line in tapHandlesSection {
            let record = EncodedRecord(name: "TapHandlesAtTapLocation", line)

            guard line.count > 1, let tapLocationNid = record.getRecNidOrNil(0) else {
                continue
            }

            var tapHandlesAtLocation: [TapHandles.TapHandleAtLocation] = []

            for i in 1 ..< line.count {
                let parts = record.getString(i).components(separatedBy: ":")
                guard let tapHandleItemNid = Int(parts[0]) else {
                    continue
                }
                let isPermanent = parts.count > 1 && parts[1] == "0" ? false : true // default to true if its an old

                tapHandlesAtLocation.append(TapHandles.TapHandleAtLocation(tapHandleItemNid: tapHandleItemNid, isPermanent: isPermanent))
            }

            tapHandlesByLocation[tapLocationNid] = tapHandlesAtLocation
        }

        let tapHandles = TapHandles(tapHandlesByLocation: tapHandlesByLocation)
        return tapHandles
    }
}
