import MobileDownload

extension OrderTypeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        isForSamples = record.getBool(3)
        isForPOS = record.getBool(4)
        isHotshotFlag = record.getBool(5)
        isForCumulativePromotions = record.getBool(6)
        isBillAndHold = record.getBool(7)
        ignoreOrderReturnPartitionRules = record.getBool(8)
        isSwap = record.getBool(9)
        doNotDEX = record.getBool(10)
        isBillAndHoldDeliver = record.getBool(11)
        excludeFromUseOnMobileDevices = record.getBool(12)
        doNotChargeCrv = record.getBool(13)
        excludeFromOneStopDiscounting = record.getBool(14)
    }
}
