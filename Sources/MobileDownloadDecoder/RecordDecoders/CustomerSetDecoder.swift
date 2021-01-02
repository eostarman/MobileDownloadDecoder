import MobileDownload

import Foundation

extension CustomerSetRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        let nCustomers = record.getInt(3)

        for i in 0 ..< nCustomers {
            let cusNid = record.getRecNidOrZero(i + 4)
            customerNids.insert(cusNid)
        }
    }
}
