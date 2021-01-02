import MobileDownload

extension ContainerRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        carrierDeposit = record.getAmount2(3)
        bagCredit = record.getAmount2(4)
        statePickupCredit = record.getAmount2(5)
        carrierDeposit2 = record.getAmount2(6)
        bagCredit2 = record.getAmount2(7)
        statePickupCredit2 = record.getAmount2(8)
        containerItemNid = record.getRecNidOrNil(9)
    }
}
