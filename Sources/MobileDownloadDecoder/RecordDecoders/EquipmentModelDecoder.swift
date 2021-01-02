import MobileDownload

extension EquipmentModelRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        infoURL = record.getString(3)
        imageValueAsHexString = record.getString(4)
        vendFillsAreInCases = record.getBool(5)
        vendFillsAreByCount = record.getBool(6)
    }
}
