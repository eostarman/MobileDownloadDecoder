import MobileDownload

extension TradingPartnerRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        // let vendorIDsByCategory: [Int:String] = [:]

        for i in 3 ..< record.fields.count {
            let categoryIDBlob = record.getString(i) // "categoryNid:vendorID"
            categoryIDBlobs.append(categoryIDBlob)
        }
    }
}
