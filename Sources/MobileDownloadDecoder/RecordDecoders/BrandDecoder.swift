import MobileDownload

extension BrandRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        privateLabelChainNid = record.getRecNidOrNil(3)
        brandFamilyNid = record.getRecNidOrNil(4)

        isStrongBeer = record.getInt(5) != 0
        isCompetitor = record.getInt(6) != 0
        isWine = record.getInt(7) != 0

        record.skip(numberOfFields: 2)
        // self.obsolete_DateCodeLabelNid = record.getRecNidOrNil(8)
        // self.obsolete_AltDateCodeLabelNid = record.getRecNidOrNil(9)

        dateCodeLabelFormat = eDateCodeLabelFormat(rawValue: record.getInt(10)) ?? .None

        beerAvailabilityNid = record.getRecNidOrNil(11)
        beerBreweryNid = record.getRecNidOrNil(12)
        continentNid = record.getRecNidOrNil(13)
        countryNid = record.getRecNidOrNil(14)
        beerCraftCategoryNid = record.getRecNidOrNil(15)
        beerGlasswareNid = record.getRecNidOrNil(16)
        beerRegionCategoryNid = record.getRecNidOrNil(17)
        beerStyleNid = record.getRecNidOrNil(18)
        beerTypeNid = record.getRecNidOrNil(19)

        brandBeverageType = eBrandBeverageType(rawValue: record.getInt(20)) ?? .NotAssigned

        isActive = record.getBool(21)
    }
}
