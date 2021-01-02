import MobileDownload

extension PurchaseCategoryRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        DisplaySequence = record.getInt(3)
        RetailerListCategory = eRetailerListCategory(rawValue: record.getInt(4))!
    }
}
