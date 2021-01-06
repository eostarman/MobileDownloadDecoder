import MobileDownload

import Foundation
import MobileDownload
import MoneyAndExchangeRates

extension PriceSheetRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        priceBookNid = record.getRecNidOrZero(3) // we get the currency and the price-book's name from here
        startDate = record.getDateOrNil(4) ?? .distantPast
        endDate = record.getDateOrNil(5)

        //perCategoryMinimums = record.getBool(6)
        perItemMinimums = record.getBool(7)
        //perPriceSheetMinimums = record.getBool(8)

        let nColumns = record.getInt(9)

        for i in 0 ..< nColumns {
            var ci = ColumnInfo()
            //ci.columnNotes = record.getString(10 + i * 7 + 0)
            ci.isAutoColumn = record.getBool(10 + i * 7 + 1)
            ci.columnMinimum = record.getInt(10 + i * 7 + 2)
            ci.isCaseMinimum = record.getBool(10 + i * 7 + 3)
            //ci.isMoneyMinimum = record.getBool(10 + i * 7 + 4)
            //ci.isWeightMinimum = record.getBool(10 + i * 7 + 5)
            //ci.basisIndex = record.getInt(10 + i * 7 + 6)

            columInfos[i] = ci
        }

        let warehouseNidBlob = record.getString(10 + nColumns * 7 + 0)
        let customerNidBlob = record.getString(10 + nColumns * 7 + 1)
        let pricesBlob = record.getString(10 + nColumns * 7 + 2)

        warehouses = Self.decodeWarehouseOrCustomerBlob(blob: warehouseNidBlob)
        customers = Self.decodeWarehouseOrCustomerBlob(blob: customerNidBlob)
        prices = Self.decodePricesBlob(pricesBlob: pricesBlob)

        record.skip(numberOfFields: 6)
//        let nAutoColumns = record.getInt(10 + nColumns * 7 + 3)
//        let nItemsInThisPriceSheet = record.getInt(10 + nColumns * 7 + 4)
//        let nWarehouses = record.getInt(10 + nColumns * 7 + 5)
//        let nCustomers = record.getInt(10 + nColumns * 7 + 6)
//        let nBasisMinimums = record.getInt(10 + nColumns * 7 + 7)
//        let nCatAccumulators = record.getInt(10 + nColumns * 7 + 8)

        endDateIsSupercededDate = record.getBool(10 + nColumns * 7 + 9)
        isDepositSchedule = record.getBool(10 + nColumns * 7 + 10)
    }

    static func decodePricesBlob(pricesBlob: String) -> [Int: [Int: MoneyWithoutCurrency]] { // PriceSheetRecord.cs
        if pricesBlob.isEmpty {
            // if the price book has no price sheets
            return [:]
        }

        var itemPrices: [Int: [Int: MoneyWithoutCurrency]] = [:]

        var n: Int? = 0
        var pricesByColumn: [Int: MoneyWithoutCurrency] = [:]

        let letterA = Character("a").asciiValue!

        for chr in pricesBlob {
            if let digit = chr.wholeNumberValue {
                n = (n ?? 0) * 10 + digit
            } else if chr == "!" {
                n = nil
            } else {
                if chr == "B" {
                    _ = n! // mpr: 4/6/09 - not supporting minimums based on, eg, "feet" - but I may see it in the data stream
                } else if chr >= "a", chr <= "k" {
                    let columnNumber = Int(chr.asciiValue! - letterA)

                    if n == nil {
                        pricesByColumn.removeValue(forKey: columnNumber)
                    } else {
                        let price = MoneyWithoutCurrency(scaledAmount: n!, numberOfDecimals: 4)
                        pricesByColumn[columnNumber] = price
                    }
                } else if chr == "I" {
                    let itemNid = n!

                    itemPrices[itemNid] = pricesByColumn // we rely on COW
                }
                n = 0
            }
        }

        return itemPrices
    }

    static func decodeWarehouseOrCustomerBlob(blob: String) -> [Int: Level] {
        var whseOrCusNid = 0
        var canUseAutomaticColumns = false
        var tempValue = 0

        var priceLevels: [Int: Level] = [:]

        for chr in blob {
            if let digit = chr.wholeNumberValue {
                tempValue = tempValue * 10 + digit
                continue
            }

            switch chr {
            case "A":
                whseOrCusNid = tempValue
                canUseAutomaticColumns = true
                tempValue = 0
            case "L":
                whseOrCusNid = tempValue
                canUseAutomaticColumns = false
                tempValue = 0
            case ",":
                let priceLevel = tempValue
                tempValue = 0

                priceLevels[whseOrCusNid] = Level(priceLevel: priceLevel, canUseAutomaticColumns: canUseAutomaticColumns)

            default:
                tempValue = 0
            }
        }

        return priceLevels
    }
}
