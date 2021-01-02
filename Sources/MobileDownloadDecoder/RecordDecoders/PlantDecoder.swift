import MobileDownload

extension PlantRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        // the blob is empty or it looks like: "1s2s3s4s..."
        suppliersAssociatedWithPlant = record.getString(3).asRecNids(separatedBy: "s")
    }
}
