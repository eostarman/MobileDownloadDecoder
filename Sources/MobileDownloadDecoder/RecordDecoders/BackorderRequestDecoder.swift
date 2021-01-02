import MobileDownload

extension BackorderRequestRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        cusNid = record.getRecNidOrZero(3)
        itemNid = record.getRecNidOrZero(4)
        qtyBackordered = record.getInt(5)
    }
}
