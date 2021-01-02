import MobileDownload

extension CoopRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        coopCustomers = record.getString(3).asRecNids(separatedBy: ",")
    }
}
