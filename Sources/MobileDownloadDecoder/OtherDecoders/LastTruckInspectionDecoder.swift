//
//  TruckInspectionDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/23/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

/// A downloaded (prior) truck-inspection
struct LastTruckInspectionDecoder {
    static func decodeLastTruckInspection(truckInspectionSection: [[String]]) -> LastTruckInspection? {
        var truckInspections: [LastTruckInspection] = []

        for line in truckInspectionSection {
            let record = EncodedRecord(name: "TruckInspection", line)

            let truckInspection = LastTruckInspection()

            truckInspection.tiInspectionNid = record.getRecNidOrNil(0) ?? 0
            truckInspection.inspectionTime = record.getDateOrNil(1) ?? .distantPast
            truckInspection.inspectorEmpNid = record.getRecNidOrNil(2) ?? 0
            truckInspection.truckNid = record.getRecNidOrNil(3) ?? 0

            guard truckInspection.tiInspectionNid > 0,
                  truckInspection.inspectionTime != .distantPast,
                  truckInspection.truckNid > 0
            else {
                continue
            }

            truckInspection.odoReading = record.getInt(4)
            truckInspection.truckCondition = record.getString(5)
            truckInspection.comment = record.getString(6)
            truckInspection.isDriverInsp = record.getBool(7)
            truckInspection.isMechanicInsp = record.getBool(8)

            _ = record.getBool(9) // DEPRECATED: bool hasNoDefects

            let nidDefects = record.getString(10)

            for nidDefect in nidDefects.components(separatedBy: ";") {
                if nidDefect.isEmpty {
                    continue
                }

                let defect = nidDefect.components(separatedBy: "-")

                // defect[0] is actually the TIInspectionNid, which we don't use anymore. It sticks around to make legacy sycning happy.
                // int inspNid = int.Parse(defect[0], CultureInfo.InvariantCulture)
                if defect.count >= 2, let itemNid = Int(defect[1]) {
                    truckInspection.defectiveTiItemNids.insert(itemNid)
                }
            }

            truckInspection.tempReading = record.getScaledDouble(11, scale: 100)
            truckInspection.truckNumber = record.getString(12)
            truckInspection.trailerNumber = record.getString(13)

            truckInspections.append(truckInspection)
        }

        return truckInspections.first
    }
}
