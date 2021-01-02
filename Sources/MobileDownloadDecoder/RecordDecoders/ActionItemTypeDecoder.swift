import MobileDownload

extension ActionItemTypeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        requiresDescription = record.getInt(3) != 0
        requiresPOS = record.getInt(4) != 0
        requiresContact = record.getInt(5) != 0
        requiresDate = record.getInt(6) != 0
    }
}
