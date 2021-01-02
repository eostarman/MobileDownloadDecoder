import MobileDownload

extension TerritoryRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        brandFamilyAssignments = Set(record.getString(3).asRecNids(separatedBy: "b"))
    }
}
