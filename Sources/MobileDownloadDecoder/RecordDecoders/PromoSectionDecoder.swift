import MobileDownload

import Foundation

extension PromoSectionRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        // Odom has a download with 20K promo sections; decoding them takes memory usage from 200MB to 300MB. If memory is an issue, we could switch
        // to a closure that populates the note and promoItems (this will still allow testing)
        setEncodedItemsAndNote(encoded: record.getString(3)) // aka promoItemsBlob

        record.skipOneField()
        // promoCustomersBlob = record.getString(4) // PromoCustomers are filtered at the PromoCode level (and PromoSections are assigned to the PromoCode)

        isMixAndMatch = record.getBool(5)
        caseMinimum = record.getInt(6)
        promoCodeNid = record.getRecNidOrZero(7)
        startDate = record.getDateOrNil(8) ?? .distantPast
        endDate = record.getDateOrNil(9)
        isBuyXGetY = record.getBool(10)
        qtyX = record.getInt(11)
        qtyY = record.getInt(12)
        isActualPrice = record.getBool(13)
        isPercentOff = record.getBool(14)
        isQualifiedPromo = record.getBool(15)
        triggerGroup1Minimum = record.getInt(16)
        triggerGroup2Minimum = record.getInt(17)
        triggerGroup3Minimum = record.getInt(18)
        triggerGroup4Minimum = record.getInt(19)
        triggerGroup5Minimum = record.getInt(20)
        isContractPromo = record.getBool(21)
        promoPlan = ePromoPlan(rawValue: record.getInt(22)) ?? .Default
        isCaseRollupPromo = record.getBool(23)
        isFullPriceTriggers = record.getBool(24)
        isDayOfWeekPromo = record.getBool(25)
        sundayPromo = record.getBool(26)
        mondayPromo = record.getBool(27)
        tuesdayPromo = record.getBool(28)
        wednesdayPromo = record.getBool(29)
        thursdayPromo = record.getBool(30)
        fridayPromo = record.getBool(31)
        saturdayPromo = record.getBool(32)
        isProratedAmount = record.getBool(33)
        additionalFeePromo_IsTax = record.getBool(34)
        isFeatured = record.getBool(35)
    }
}
