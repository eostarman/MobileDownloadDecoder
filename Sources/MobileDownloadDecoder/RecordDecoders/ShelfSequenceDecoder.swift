import MobileDownload

extension ShelfSequenceRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        numberOfAltPacks = record.getInt(3)
        altPackFamilyNidsBlob = record.getString(4)
    }
}
