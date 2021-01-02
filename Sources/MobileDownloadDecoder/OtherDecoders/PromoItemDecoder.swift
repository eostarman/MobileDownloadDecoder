//
//  PromoItemService.swift
//  MobileBench
//
//  Created by Michael Rutherford on 7/20/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload


// this will parse the promoItemBlob from a promo section
struct PromoItemDecoder {
    static func getPromoItemsAndNote(blob: String, promoSectionNid: Int) -> PromoSectionRecord.ItemsAndNote {
        var items: [PromoItem] = []

        var unitRate: Int = 0
        var unitRateType: PromoItem.ePromoRateType = .amountOff
        var fromDateOverride: Date?
        var thruDateOverride: Date?
        var note: String?
        var isExplicitTriggerItem = false // added support 7/31/07

        var triggerGroup = 0

        let chr_n = "n".utf8.first!
        let singleQuote = "'".utf8.first!
        let zero = "0".utf8.first!
        let nine = "9".utf8.first!
        let chr_dash = "-".utf8.first!

        let chr_p = "p".utf8.first!
        let chr_a = "a".utf8.first!
        let chr_x = "x".utf8.first!
        let chr_s = "s".utf8.first!
        let chr_e = "e".utf8.first!
        let chr_t = "t".utf8.first!
        let chr_g = "g".utf8.first!
        let chr_f = "f".utf8.first!
        let chr_r = "r".utf8.first!
        let chr_i = "i".utf8.first!

        var string: [UInt8] = []
        var insideString = false
        var sawQuoteInsideString = false

        var isNegativeNumber = false
        var tempValue = 0

        // 'xxx''yyy'n
        for chr in blob.utf8 {
            if insideString {
                if chr == singleQuote {
                    if sawQuoteInsideString {
                        string.append(chr)
                        sawQuoteInsideString = false
                    } else {
                        sawQuoteInsideString = true
                    }
                } else if sawQuoteInsideString {
                    if chr == chr_n {
                        note = String(bytes: string, encoding: .utf8)
                        string = []
                        insideString = false
                        sawQuoteInsideString = false
                    }
                } else {
                    string.append(chr)
                }
                continue
            }

            if chr == singleQuote {
                insideString = true
                continue
            }

            if chr >= zero, chr <= nine {
                let digit = Int(chr - zero)
                tempValue = tempValue * 10 + digit
                continue
            }

            if chr == chr_dash {
                isNegativeNumber = true
                continue
            }

            let value = isNegativeNumber ? -tempValue : tempValue
            tempValue = 0
            isNegativeNumber = false

            switch chr {
            case chr_p:
                unitRate = value
                unitRateType = .percentOff
            case chr_a:
                unitRate = value
                unitRateType = .amountOff
            case chr_x:
                unitRate = value
                unitRateType = .promoPrice
            case chr_s:
                // startDate = Date.fromyyyyMMdd(value)
                break
            case chr_e:
                // endDate = value == 0 ? nil : Date.fromyyyyMMdd(value)
                break
            case chr_t:
                isExplicitTriggerItem = (value == 1)
            case chr_g:
                triggerGroup = value
            case chr_f:
                fromDateOverride = value == 0 ? nil : Date.fromyyyyMMdd(value)
            case chr_r:
                thruDateOverride = value == 0 ? nil : Date.fromyyyyMMdd(value)
            case chr_i:
                let itemNid = value
                var promoItem = PromoItem()
                promoItem.promoSectionNid = promoSectionNid
                promoItem.itemNid = itemNid
                promoItem.isExplicitTriggerItem = isExplicitTriggerItem
                promoItem.triggerGroup = triggerGroup
                promoItem.promoRateType = unitRateType
                promoItem.promoRate = unitRate
                promoItem.fromDateOverride = fromDateOverride
                promoItem.thruDateOverride = thruDateOverride

                items.append(promoItem)
            default:
                break
            }
        }

        return PromoSectionRecord.ItemsAndNote(promoItems: items, note: note)
    }
}
