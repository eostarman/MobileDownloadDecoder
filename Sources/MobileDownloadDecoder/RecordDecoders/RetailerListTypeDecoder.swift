import MobileDownload

extension RetailerListTypeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        displaySequence = record.getInt(3)
        retailerListCategory = eRetailerListCategory(rawValue: record.getInt(4))!
    }
}
