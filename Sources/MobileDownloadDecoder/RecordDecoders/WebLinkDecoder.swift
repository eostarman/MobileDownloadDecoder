import MobileDownload

import Foundation

extension WebLinkRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        itemNid = record.getRecNidOrNil(3)
        brandNid = record.getRecNidOrNil(4)
        customerNid = record.getRecNidOrNil(5)
        chainNid = record.getRecNidOrNil(6)
        webURL = record.getString(7)
        webLinkAudienceNid = record.getRecNidOrNil(8)
        fromDate = record.getDateOrNil(9)
        thruDate = record.getDateOrNil(10)
        customerRuleNidBlob = record.getString(11)
        itemRuleNidBlob = record.getString(12)
        webLinkContentType = eWebLinkContentType(rawValue: record.getInt(13))!
    }
}
