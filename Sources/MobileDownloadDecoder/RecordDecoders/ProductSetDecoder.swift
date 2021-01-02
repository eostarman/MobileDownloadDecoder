import MobileDownload

import Foundation

extension ProductSetRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        let nAltPackFamilies = record.getInt(3)

        for i in 0 ..< nAltPackFamilies {
            let altPackFamilyNid = record.getRecNidOrZero(4 + i)
            altPackFamilyNids.insert(altPackFamilyNid)
        }
    }
}
