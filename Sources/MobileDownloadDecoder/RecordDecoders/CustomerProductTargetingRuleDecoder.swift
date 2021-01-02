import MobileDownload

import Foundation

extension CustomerProductTargetingRuleRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        description = record.getString(3)
        fromDate = record.getDateOrNil(4)
        thruDate = record.getDateOrNil(5)
        targetProducts = Set(record.getString(6).asRecNids(separatedBy: ","))
        targetCustomers = Set(record.getString(7).asRecNids(separatedBy: ","))
        ignoreDidBuy = record.getBool(8)
        ignorePresellProductSet = record.getBool(9)
        requiresOnlyOneSale = record.getBool(10)
    }
}
