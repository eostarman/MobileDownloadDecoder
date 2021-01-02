import MobileDownload

import Foundation

extension MinimumOrderQtyRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        productSetNid = record.getRecNidOrNil(3)
        minQty = record.getInt(4)
        customerSetNid = record.getRecNidOrNil(5)
        effectiveDate = record.getDateOrNil(6) ?? .distantPast
        cusNids = Set(record.getString(7).asRecNids(separatedBy: ","))
        itemNids = Set(record.getString(8).asRecNids(separatedBy: ","))
        Note = record.getString(9)
    }
}
