//
//  CusAllocationsDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/22/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct CusAllocationsDecoder {
    static func decodeCusAllocations(cusAllocationsSection: [[String]]) -> [ItemAllocation] {
        var allocations: [ItemAllocation] = []

        let blob = cusAllocationsSection

        if blob.isEmpty {
            return []
        }

        for line in blob {
            if line.isEmpty {
                continue
            }

            let flds = EncodedRecord(name: "CusAllocations", line)

            let cusNid = flds.getInt(0)
            let itemNid = flds.getInt(1)
            let allocationDate = flds.getDateOrNil(2) ?? .distantPast
            let allocationThruDate = flds.getDateOrNil(3) ?? .distantFuture
            let qtyAllocated = flds.getInt(4)
            let qtyDelivered = flds.getInt(5)
            let whseNid = flds.getInt(6)
            let note = flds.getString(7)

            var allocation = ItemAllocation()
            allocation.whseNid = whseNid
            allocation.cusNid = cusNid
            allocation.itemNid = itemNid
            allocation.note = note
            allocation.allocationDate = allocationDate
            allocation.allocationThruDate = allocationThruDate
            allocation.qtyAllocated = qtyAllocated
            allocation.qtyDelivered = qtyDelivered

            allocations.append(allocation)
        }

        return allocations
    }
}
