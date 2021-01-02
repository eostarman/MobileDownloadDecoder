import MobileDownload

extension ServiceZoneRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        serviceTechEmpNid = record.getRecNidOrNil(3)
        temporaryServiceTechEmpNid = record.getRecNidOrNil(4)
    }
}
