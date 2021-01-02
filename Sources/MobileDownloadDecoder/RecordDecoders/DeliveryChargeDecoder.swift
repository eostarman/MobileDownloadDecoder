import MobileDownload

extension DeliveryChargeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        chargeIsBasedOnQty = record.getInt(3) != 0
        isFlatCharge = record.getInt(4) != 0
        chargeAmount = record.getAmount4(5)
        threshold = record.getAmount2(6)
        // self.obsolete_chargeFirstOrderOnlyForMultipleOrderDeliveries = record.getInt(7) // removed 2016/03/18
        applyChargeToFreeGoods = record.getInt(8) != 0
    }
}
