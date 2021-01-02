import MobileDownload

extension ProductClassRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        isAlcohol = record.getBool(3) // get this (to retain webservice compatibility with old versions) but it's not correct and shouldn't be used
        isActive = record.getBool(4)
        HasStrictSalesEnforcement = record.getBool(5)
    }
}
