import MobileDownload

import Foundation

extension VendPlanogramRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        planogramFromDate = record.getDateOrNil(3)
        planogramThruDate = record.getDateOrNil(4)
        vendInventoryBlob = record.getString(5)
    }
}
