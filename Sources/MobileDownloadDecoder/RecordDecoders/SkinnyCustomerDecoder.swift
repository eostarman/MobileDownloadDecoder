import MobileDownload

extension SkinnyCustomerRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        var flags = EncodedFlags(flags: record.getString(3))

        shipLatitude = record.getDoubleOrNil(4)
        shipLongitude = record.getDoubleOrNil(5)
        shipCity = record.getString(6)
        shipState = record.getString(7)
        tdLinxChannel = record.getInt(8)
        tdLinxSubChannel = record.getInt(9)
        tdLinxFoodType = record.getInt(10)
        tdLinxNeighborhood = record.getInt(11)
        slsChanNid = record.getRecNidOrNil(12)
        geoAreaNid = record.getRecNidOrNil(13)
        chainNid = record.getRecNidOrNil(14)
        whseNid = record.getRecNidOrZero(15)

        activeFlag = flags.getFlag(0)
        isOffPremise = flags.getFlag(1)
        isNonRetail = flags.getFlag(2)
        isDistributor = flags.getFlag(3)
    }
}
