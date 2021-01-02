//
//  ArInfoDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/23/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct ArInfoDecoder {
    static func decodeArInfoRecords(arInfoSection: [[String]]) -> [ArInfoRecord] {
        var arInfoRecords: [ArInfoRecord] = []

        for line in arInfoSection {
            let record = EncodedRecord(name: "ArInfoRecord", line)

            let arInfoRecord = ArInfoRecord()
            arInfoRecord.decodeFrom(record)
            arInfoRecords.append(arInfoRecord)
        }

        return arInfoRecords
    }
}

extension ArInfoRecord {
    func decodeFrom(_ record: EncodedRecord) {
        cusNid = record.getRecNidOrNil(0) ?? 0
        recvDate = record.getDateOrNil(1) ?? Date()
        billToNid = record.getRecNidOrNil(2) ?? cusNid
        let originalAmount = record.getAmount2(3)
        let totalOwed = record.getAmount2(4)
        dueByDate = record.getDateOrNil(5)
        let pastDueAmount = record.getAmount2(6)
        let openCredit = record.getAmount2(7)
        fullDescription = record.getString(8)
        receivablesNote = record.getString(9)
        companyNid = record.getCompanyNid(10)
        ticketNumber = record.getInt(11)
        isCusPayment = record.getBool(12)
        isCusCharge = record.getBool(13)
        isOrder = record.getBool(14)
        paymentTermsNid = record.getRecNidOrNil(15)
        isEscrow = record.getBool(16)
        isPOA = record.getBool(17)
        let transactionCurrency = Currency(currencyNid: record.getRecNidOrNil(18)) ?? .USD
        record.skipOneField()
        // let accountingCurrency = Currency(currencyNid: record.getRecNidOrNil(19)) ?? .USD

        self.originalAmount = originalAmount.withCurrency(transactionCurrency)
        self.totalOwed = totalOwed.withCurrency(transactionCurrency)
        self.pastDueAmount = pastDueAmount.withCurrency(transactionCurrency)
        self.openCredit = openCredit.withCurrency(transactionCurrency)
    }
}
