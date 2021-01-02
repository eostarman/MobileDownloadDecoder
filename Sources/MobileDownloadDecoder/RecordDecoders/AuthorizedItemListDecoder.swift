import MobileDownload

extension AuthorizedItemListRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        record.skipOneField()
        // nItems = record.getInt(3)
        itemNids = Set(record.getString(4).asRecNids(separatedBy: ","))
    }
}
