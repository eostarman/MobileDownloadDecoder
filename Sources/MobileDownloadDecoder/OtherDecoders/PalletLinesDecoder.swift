//
//  PalletLineService.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 8/29/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct PalletLinesDecoder {
    static func decodePalletLines(palletLinesSection: [[String]]) -> [PalletLine] {
        let blobs = palletLinesSection

        var lines: [PalletLine] = []

        for blob in blobs {
            if blob.count < 5 { // ignore empty lines (count 0) and also bad data (too few fields)
                continue
            }
            let orderNumber = Int(blob[0]) ?? 0
            let palletID = String(blob[1])
            let itemNid = Int(blob[2]) ?? 0
            let completionSeq = Int(blob[3]) ?? 0
            let qty = Int(blob[4]) ?? 0
            let bay = BayNumber(blob.count < 6 ? "" : String(blob[5])) // old web services didn't have the trailer location

            if orderNumber == 0 || itemNid == 0 { // bad data
                continue
            }

            var line = PalletLine()
            line.orderNumber = orderNumber
            line.palletID = palletID
            line.itemNid = itemNid
            line.completionSeq = completionSeq
            line.qty = qty
            line.bayNumber = bay

            lines.append(line)
        }

        return lines
    }
}
