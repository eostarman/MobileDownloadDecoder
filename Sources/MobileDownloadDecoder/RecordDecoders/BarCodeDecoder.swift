import MobileDownload

extension BarCodeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        itemNid = record.getRecNidOrZero(3)
    }
}
