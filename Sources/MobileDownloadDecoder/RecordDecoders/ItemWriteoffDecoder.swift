import MobileDownload

extension ItemWriteoffRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        isReturnReasonFlag = record.getBool(3)
        isDeliveryAdjustmentReasonFlag = record.getBool(4)
        basePricesAndPromosOnQtyOrdered = record.getBool(5)
        dateCodeEntryRequired = record.getBool(6)
        notForUseOnMobileDevices = record.getBool(7)
        useDeliveryDayPriceForReturns = record.getBool(8)
        autoPutaway = eAutoPutaway(rawValue: record.getInt(9))!
        returnedProductIsNonSellable = record.getBool(10)
        isValidForInMarket = record.getBool(11)
        doNotUseForAlcoholStates = record.getString(12)
    }
}
