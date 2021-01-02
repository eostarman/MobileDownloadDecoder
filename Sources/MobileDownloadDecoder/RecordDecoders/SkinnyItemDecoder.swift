import MobileDownload

import Foundation

extension SkinnyItemRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        var flags = EncodedFlags(flags: record.getString(3))

        activeFlag = flags.getFlag(0)

        monthlySalesBlob = record.getString(4)
        encodedAltPackString = record.getString(5)
        brandNid = record.getRecNidOrNil(6)
        gallonsPerCase = record.getScaledDecimal(7, scale: 4)
        SupNid = record.getRecNidOrNil(8)
        caseUPC = record.getString(9)
        retailUPC = record.getString(10)
    }
}
