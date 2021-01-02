import MobileDownload

import Foundation

extension AdAlertRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        var flags = EncodedFlags(flags: record.getString(3))

        fromDate = record.getDateOrNil(4) ?? .distantPast
        thruDate = record.getDateOrNil(5) ?? .distantFuture
        promoTypeRecName = record.getString(6)
        displayAuthRecName = record.getString(7)
        displayLocationRecName = record.getString(8)
        promoTypeCode = record.getString(9)
        comments = record.getString(10)
        promoTypePriority = record.getInt(11)
        unitPrice = record.getInt(12)
        minCaseRequirement = record.getInt(13)
        cusNids = record.getString(14).asRecNids(separatedBy: ",")
        customerRulesDescription = record.getString(15)
        itemNids = record.getString(16).asRecNids(separatedBy: ",")
        productRulesDescription = record.getString(17)
        complianceBytesBlob = record.getString(18)

        acknowledgementRequiredAtTimeOfService = flags.getFlag(0)
        logIsPriceCompliant = flags.getFlag(1)
        logIsDisplayCompliant = flags.getFlag(2)
        logIsPOSCompliant = flags.getFlag(3)
        adAlertFirstVisitCompliance = flags.getFlag(4)
        adAlertSecondVisitCompliance = flags.getFlag(5)
        adAlertOnOrBeforeLastVisitCompliance = flags.getFlag(6)
    }
}
