import MobileDownload

extension TIItemRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        sequence = record.getInt(3)
        tiCategoryNid = record.getRecNidOrZero(4)
    }
}
