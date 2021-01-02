import MobileDownload

extension CountyRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        BlacklistLikeCountyNid = record.getRecNidOrNil(3)
        blacklistedBrands = Set(record.getString(4).asRecNids(separatedBy: ","))
    }
}
