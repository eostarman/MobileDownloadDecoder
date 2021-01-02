//
//  CusSpecialPricesDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/23/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct CusSpecialPricesDecoder {
    static func decodeSpecialPrices(blob: String) -> [SpecialPrice]? {
        if blob.isEmpty {
            return nil
        }

        var prices: [SpecialPrice] = []

        var n = 0
        var price: MoneyWithoutCurrency?
        var startDate: Date?
        var thruDate: Date?

        for chr in blob {
            if let digit = chr.wholeNumberValue {
                n = n * 10 + digit
                continue
            }

            switch chr {
            case "p":
                price = MoneyWithoutCurrency(scaledAmount: n, numberOfDecimals: 2)
            case "s":
                startDate = Date.fromyyyyMMdd(String(n))
            case "t":
                thruDate = n == 0 ? nil : Date.fromyyyyMMdd(String(n))
            case "i":
                let itemNid = n
                let actualStartDate = startDate ?? Date.fromyyyyMMdd("20000101")!
                if let price = price, itemNid > 0 {
                    var specialPrice = SpecialPrice()
                    specialPrice.startDate = actualStartDate
                    specialPrice.endDate = thruDate
                    specialPrice.itemNid = itemNid
                    specialPrice.price = price

                    prices.append(specialPrice)
                }
            default:
                break
            }

            n = 0
        }

        if prices.isEmpty {
            return nil
        }

        return prices
    }
}
