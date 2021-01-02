import MobileDownload

import Foundation

extension SalesBalancingRuleRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        cusQtyLimit = record.getIntOrNil(3)
        empQtyLimit = record.getIntOrNil(4)
        rulePeriod = eSalesBalancingRulePeriod(rawValue: record.getInt(5))!
        fromDate = record.getDateOrNil(6) ?? .distantPast
        thruDate = record.getDateOrNil(7) ?? .distantFuture
        cusNidStr = record.getString(8)
        itemNidStr = record.getString(9)
        cusExceptionsString = record.getString(10)
        empExceptionsString = record.getString(11)
        Note = record.getString(12)
    }
}
