import MobileDownload

extension TruckRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        stripTruckFlag = record.getBool(3)
        record.skipOneField()
        // obsolete_PType = record.getInt(4)
        productClassBit1 = record.getBool(5)
        productClassBit2 = record.getBool(6)
        productClassBit3 = record.getBool(7)
        productClassBit4 = record.getBool(8)
        productClassBit5 = record.getBool(9)
        whseNid = record.getRecNidOrZero(10)
        returnWhseNid = record.getRecNidOrNil(11)
        productClassBit6 = record.getBool(12)
        productClassBit7 = record.getBool(13)
        productClassBit8 = record.getBool(14)
        productClassBit9 = record.getBool(15)
        productClassBit10 = record.getBool(16)
        defaultTruckStripType = record.getInt(17)
        serviceTruckFlag = record.getBool(18)
        truckUsesPreorders = record.getBool(19)
    }
}
