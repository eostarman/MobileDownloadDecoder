import MobileDownload

import Foundation

extension SplitCaseChargeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        amount = record.getAmount2(3)
        productSetNid = record.getRecNidOrZero(4)
        isPerAltPackCharge = record.getBool(5)
        cutoffPrice = record.getAmount2OrNil(6)
        effectiveDate = record.getDateOrNil(7)
    }
}
