//
//  MobileDownloadHeaderDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/26/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct MobileDownloadHeaderDecoder {
    static func decodeMobileDownloadHeader(headerSection: [[String]]) -> MobileDownload.Header {
        guard let headerRecord = headerSection.first else {
            return MobileDownload.Header()
        }

        let header = MobileDownload.Header()

        let record = EncodedRecord(name: "MobileDownload.Header", headerRecord)

        header.startTime = record.getDateTimeOrNil(0) ?? Date()
        header.stopTime = record.getDateTimeOrNil(1) ?? Date()
        header.serverName = record.getString(2)
        header.databaseName = record.getString(3)
        header.numberOfTables = record.getInt(4)
        header.totalNumberOfRecords = record.getInt(5)
        header.isProductionDatabase = record.getString(6) == "1"

        return header
    }
}
