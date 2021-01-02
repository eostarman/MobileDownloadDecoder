import MobileDownload

extension PermitRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        let itemNidBlob = record.getString(3)
        altPackFamilyNids = itemNidBlob.isEmpty ? nil : Set(itemNidBlob.asRecNids(separatedBy: ","))
    }
}
