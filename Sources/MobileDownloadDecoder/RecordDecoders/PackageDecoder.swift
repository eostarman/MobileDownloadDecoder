import MobileDownload

extension PackageRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        unitDeliveryCharge = record.getAmount2(3)
        unitFreight = record.getAmount2(4)
        primaryPackSingular = record.getString(5)
        primaryPackPlural = record.getString(6)
        retailPack1Singular = record.getString(7)
        retailPack1Plural = record.getString(8)
        retailPack1UnitsPerCase = record.getInt(9)
        retailPack2Singular = record.getString(10)
        retailPack2Plural = record.getString(11)
        retailPack2UnitsPerCase = record.getInt(12)
        returnedEmptyItemNidOrZero = record.getString(13)
        casesPerLayerByPalletSizeNidBlob = record.getString(14)
        prefersKegDeliveryRoute = record.getBool(15)
        packageTypeNid = record.getRecNidOrNil(16)
    }
}
