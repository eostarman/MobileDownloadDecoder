//
//  TaxRatesDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/23/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct TaxRatesDecoder {
    static func decodeTaxRates(taxRatesSection: [[String]]) -> [TaxRateRecord] {
        var rates: [TaxRateRecord] = []

        for line in taxRatesSection {
            let record = EncodedRecord(name: "TaxRates", line)

            let rate = TaxRateRecord()
            rate.decodeFrom(record)
            rates.append(rate)
        }

        return rates
    }
}

extension TaxRateRecord {
    func decodeFrom(_ record: EncodedRecord) {
        taxAreaNid = record.getRecNidOrNil(0) ?? 0
        taxClassNid = record.getRecNidOrNil(1) ?? 0

        stateEffectiveDate = record.getDateOrNil(2)
        countyEffectiveDate = record.getDateOrNil(3)
        cityEffectiveDate = record.getDateOrNil(4)
        localEffectiveDate = record.getDateOrNil(5)

        stateSupercededDate = record.getDateOrNil(6)
        countySupercededDate = record.getDateOrNil(7)
        citySupercededDate = record.getDateOrNil(8)
        localSupercededDate = record.getDateOrNil(9)

        record.skip(numberOfFields: 8)
        // oldStateEffectivePct = record.getDecimal3(10, scale: 1_000)
        // oldCountyEffectivePct = record.getDecimal3(11, scale: 1_000)
        // oldCityEffectivePct = record.getDecimal3(12, scale: 1_000)
        // oldLocalEffectivePct = record.getDecimal3(13, scale: 1_000)

        // oldStateSupercededPct = record.getDecimal3(14, scale: 1_000)
        // oldCountySupercededPct = record.getDecimal3(15, scale: 1_000)
        // oldCitySupercededPct = record.getDecimal3(16, scale: 1_000)
        // oldLocalSupercededPct = record.getDecimal3(17, scale: 1_000)

        stateEffectivePct = record.getScaledDouble(18, scale: 10000)
        countyEffectivePct = record.getScaledDouble(19, scale: 10000)
        cityEffectivePct = record.getScaledDouble(20, scale: 10000)
        localEffectivePct = record.getScaledDouble(21, scale: 10000)

        stateSupercededPct = record.getScaledDouble(22, scale: 10000)
        countySupercededPct = record.getScaledDouble(23, scale: 10000)
        citySupercededPct = record.getScaledDouble(24, scale: 10000)
        localSupercededPct = record.getScaledDouble(25, scale: 10000)

        isPct = record.getBool(26)
        isRatePerGallon = record.getBool(27)

        stateTaxScheduleNid = record.getRecNidOrNil(28)
        countyTaxScheduleNid = record.getRecNidOrNil(29)
        cityTaxScheduleNid = record.getRecNidOrNil(30)
        localTaxScheduleNid = record.getRecNidOrNil(31)

        stateSupercededTaxScheduleNid = record.getRecNidOrNil(32)
        countySupercededTaxScheduleNid = record.getRecNidOrNil(33)
        citySupercededTaxScheduleNid = record.getRecNidOrNil(34)
        localSupercededTaxScheduleNid = record.getRecNidOrNil(35)

        wholesaleEffectiveDate = record.getDateOrNil(36)
        wholesaleSupercededDate = record.getDateOrNil(37)
        wholesaleEffectivePct = record.getScaledDouble(38, scale: 10000)
        wholesaleSupercededPct = record.getScaledDouble(39, scale: 10000)
        wholesaleTaxScheduleNid = record.getRecNidOrNil(40)
        wholesaleSupercededTaxScheduleNid = record.getRecNidOrNil(41)

        isRatePerLiter = record.getBool(42)
        isPctOfMTV = record.getBool(43)

        vatEffectiveDate = record.getDateOrNil(44)
        vatSupercededDate = record.getDateOrNil(45)
        vatEffectivePct = record.getScaledDouble(46, scale: 10000)
        vatSupercededPct = record.getScaledDouble(47, scale: 10000)
        // vatScheduleNid = record.getRecNidOrNil()
        // vatSupercededTaxScheduleNid = record.getRecNidOrNil()

        levyEffectiveDate = record.getDateOrNil(48)
        levySupercededDate = record.getDateOrNil(49)
        levyEffectivePct = record.getScaledDouble(50, scale: 10000)
        levySupercededPct = record.getScaledDouble(51, scale: 10000)
        // levyScheduleNid = record.getRecNidOrNil()
        // levySupercededTaxScheduleNid = record.getRecNidOrNil()
    }
}
