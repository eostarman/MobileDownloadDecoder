import MobileDownload


extension HoldCodeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        noSellFlag = record.getInt(3) != 0
        mustPayFlag = record.getInt(4) != 0
    }
}
