import MobileDownload

extension TradingPartnerSupplementRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        isDEX4010 = record.getBool(3)
        sendTotalsInFinalDEXAck = record.getBool(4)
        neverDEXSwapOrders = record.getBool(5)
        packSizeOverridesBlob = record.getString(6)
        vendorIDAndDEXLocationOverridesBlob = record.getString(7)
        neverDEXCreditInvoices = record.getBool(8)
        convertCasesToPacksForEADex = record.getBool(9)
        customerSpecificVendorIDOverridesBlob = record.getString(10)
        vendorID = record.getString(11)
    }
}
