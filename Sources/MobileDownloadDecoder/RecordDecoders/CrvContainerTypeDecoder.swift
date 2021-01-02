import MobileDownload

extension CrvContainerTypeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        taxRate = record.getAmount2(3) // California Redemption Value is USD
    }
}
