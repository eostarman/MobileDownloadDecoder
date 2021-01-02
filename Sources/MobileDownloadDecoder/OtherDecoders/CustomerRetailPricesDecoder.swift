//
//  CusRetailPricesDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/24/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct CustomerRetailPricesDecoder {
    // note that in this example the price is $1.00 for items 3111, 3189, 4165, ...
    // "100p3111i3189i4165i4897i5144i5148i6452i6827i8628i11889i11963i27561i30147i36787i43889i200p2828i3318i5577i6476i6887i7747i11184i12035i300p1663i2117i9504i400p4140i8980i9469i500p6349i600p233i8415i700p10243i800p7755i"

    static func decodeRetailPrices(retailPricesBlob: String) -> [CustomerRetailPrice] {
        if retailPricesBlob.isEmpty {
            return []
        }

        var price: MoneyWithoutCurrency = .zero
        var n = 0

        var prices: [CustomerRetailPrice] = []

        for chr in retailPricesBlob {
            if let digit = chr.wholeNumberValue {
                n = n * 10 + digit
                continue
            } else {
                if chr == "p" {
                    price = MoneyWithoutCurrency(scaledAmount: n, numberOfDecimals: 2)
                } else if chr == "i" {
                    let itemNid = n
                    if itemNid > 0 {
                        prices.append(CustomerRetailPrice(itemNid: n, price: price))
                    }
                }
                n = 0
            }
        }

        return prices
    }
}
