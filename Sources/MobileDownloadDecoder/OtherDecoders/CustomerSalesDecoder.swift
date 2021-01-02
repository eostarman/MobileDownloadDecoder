//
//  CusItemSaleService.swift
//  MobileBench
//
//  Created by Michael Rutherford on 7/15/20.
//
//  compare to CusItemSales in c#

import Foundation
import MoneyAndExchangeRates
import MobileDownload


struct CustomerSalesDecoder {
    static func decodeSalesHistory(cusNid: Int, itemHistoryBlob: String) -> [CusItemSale] {
        var saleId = 0

        var isNegative = false
        var tempValue = 0
        var maxDate = Date.distantPast

        var sales: [CusItemSale] = []

        var additionalFeeIgnoreHistory: Bool = false
        var itemNid: Int = 0
        var orderNumber: Int = 0
        var orderedDate = Date.distantPast
        var deliveryDate: Date?
        var isDelivered: Bool = false
        var qtyOrdered: Int = 0
        var qtyShipped: Int = 0
        var unitPrice: MoneyWithoutCurrency = .zero
        var unitDisc: MoneyWithoutCurrency = .zero
        var unitDeposit: MoneyWithoutCurrency = .zero
        var cmaOnAmt: MoneyWithoutCurrency = .zero
        var ctmOnAmt: MoneyWithoutCurrency = .zero
        var ccfOnAmt: MoneyWithoutCurrency = .zero
        var cmaOffAmt: MoneyWithoutCurrency = .zero
        var ctmOffAmt: MoneyWithoutCurrency = .zero
        var ccfOffAmt: MoneyWithoutCurrency = .zero
        var seq: Int = 0
        var autoFreeGoodsLine: Bool = false

        for chr in itemHistoryBlob {
            if chr == "-" {
                isNegative = true
                continue
            }

            if let digit = chr.wholeNumberValue {
                tempValue = tempValue * 10 + digit
                continue
            }

            let value = isNegative ? -tempValue : tempValue
            isNegative = false
            tempValue = 0

            switch chr {
            case "b": maxDate = Date.fromyyyyMMdd(value)!
            case "c": cmaOffAmt = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "d": unitDisc = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "e": unitDeposit = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "f": isDelivered = value != 0
            case "g": ctmOffAmt = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "h": ccfOffAmt = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "j": cmaOnAmt = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "k": ctmOnAmt = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "l": ccfOnAmt = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "m": autoFreeGoodsLine = value != 0
            case "n": seq = value
            case "p": unitPrice = MoneyWithoutCurrency(scaledAmount: value, numberOfDecimals: 4)
            case "q": qtyShipped = value
            case "s": orderedDate = Calendar.current.date(byAdding: .day, value: -value, to: maxDate)!
            case "t": orderNumber = value
            // case "w": weekDayForMaxDate = value
            case "y": deliveryDate = Date.fromyyyyMMdd(value)
            case "z": qtyOrdered = value
            case "%": additionalFeeIgnoreHistory = true

            case "i":
                itemNid = value
                saleId += 1
                let sale = CusItemSale()
                sale.id = saleId
                sale.additionalFeeIgnoreHistory = additionalFeeIgnoreHistory
                sale.cusNid = cusNid
                sale.itemNid = itemNid
                sale.orderNumber = orderNumber
                sale.orderedDate = orderedDate
                sale.deliveryDate = deliveryDate
                sale.isDelivered = isDelivered
                sale.qtyOrdered = qtyOrdered
                sale.qtyShipped = qtyShipped
                sale.unitPrice = unitPrice
                sale.unitDisc = unitDisc
                sale.unitDeposit = unitDeposit
                sale.cmaOnAmt = cmaOnAmt
                sale.ctmOnAmt = ctmOnAmt
                sale.ccfOnAmt = ccfOnAmt
                sale.cmaOffAmt = cmaOffAmt
                sale.ctmOffAmt = ctmOffAmt
                sale.ccfOffAmt = ccfOffAmt
                sale.seq = seq
                sale.autoFreeGoodsLine = autoFreeGoodsLine

                sales.append(sale)
            default:
                continue
            }
        }

        return sales
    }
}
