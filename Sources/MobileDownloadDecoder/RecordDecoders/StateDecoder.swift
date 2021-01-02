import MobileDownload

extension StateRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        stateTaxBDescription = record.getString(3)
        salesTaxStateBBlob = record.getString(4)
        stateTaxCDescription = record.getString(5)
        salesTaxStateCBlob = record.getString(6)
        deliveryChargeAmount = record.getAmount2(7)
        refuseDEXPriceChanges = record.getBool(8)
        alcoholCompliancePaymentTermsNid = record.getRecNidOrNil(9)
        alcoholCompliancePaymentTermsApplyToAlcoholOnly = record.getBool(10)
        alcoholComplianceHoldCodeNid = record.getRecNidOrNil(11)
        alcoholComplianceCusNids = Set(record.getString(12).asRecNids(separatedBy: ","))
        doesNotCreditBackSplitCaseCharges = record.getBool(13)
        restrictDiscountBasedOnDeliveryDate = record.getBool(14)
        restrictKegBeerDiscountDays = record.getInt(15)
        restrictOtherBeerDiscountDays = record.getInt(16)
    }
}
