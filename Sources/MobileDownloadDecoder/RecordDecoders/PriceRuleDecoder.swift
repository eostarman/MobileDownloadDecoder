import MobileDownload

extension PriceRuleRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        shipFromWhseNid = record.getRecNidOrNil(3)
        priceBookNid = record.getRecNidOrZero(4)
        priceLevel = record.getInt(5)
        canUseAutomaticColumns = record.getBool(6)
    }
}
