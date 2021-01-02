//
//  CusPermitsDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/23/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct CusPermitsDecoder {
    static func decodeCusPermits(cusNid: Int, cusPermitBlob: String) -> [CusPermit] {
        var cusPermits: [CusPermit] = []

        if cusPermitBlob.isEmpty {
            return cusPermits
        }

        let permitBlobs = cusPermitBlob.components(separatedBy: ";")

        for blob in permitBlobs {
            let fields = blob.components(separatedBy: ",") // PermitNid, License#, Status, ThruDate

            let permitNid = Int(fields[0]) ?? 0
            let licenseNumber = fields[1]
            let isDelinquent = fields[2] == "d"
            let isSuspended = fields[2] == "s"
            let isCancelled = fields[2] == "c"
            let thruDate = Date.fromyyyyMMdd(fields[3])!

            var cusPermit = CusPermit()
            cusPermit.cusNid = cusNid
            cusPermit.permitNid = permitNid
            cusPermit.licenseNumber = licenseNumber
            cusPermit.thruDate = thruDate
            cusPermit.isSuspended = isSuspended
            cusPermit.isDelinquent = isDelinquent
            cusPermit.isCancelled = isCancelled

            cusPermits.append(cusPermit)
        }

        return cusPermits
    }
}
