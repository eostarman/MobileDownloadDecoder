import MobileDownload

import Foundation

extension ItemRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        let itemNid = record.getRecNidOrZero(0)
        recNid = itemNid
        recKey = record.getString(1)
        recName = record.getString(2)
        packageNid = record.getRecNidOrNil(3)
        brandNid = record.getRecNidOrNil(4)
        categoryNid = record.getRecNidOrNil(5)
        taxClassNid = record.getRecNidOrNil(6)
        packName = record.getString(7)
        defaultPrice = record.getAmount4OrNilIfNegativeOne(8)
        deposit = record.getAmount4OrNil(9)
        itemWeight = record.getScaledDouble(10, scale: 100)
        outOfStockDate = record.getDateOrNil(11)

        var flags = EncodedFlags(flags: record.getString(12))

        canBuy = flags.getFlag(0)
        canIssue = flags.getFlag(1)
        canSell = flags.getFlag(2)
        isPart = flags.getFlag(3)
        isBillingCode = flags.getFlag(4)
        canOverrideRecName = flags.getFlag(5)
        isSerialized = flags.getFlag(6)
        depositIsSupplierOriginated = flags.getFlag(7)
        isAlcohol = flags.getFlag(8)
        isEmpty = flags.getFlag(9)
        isKeg = flags.getFlag(10)
        isCase = flags.getFlag(11)
        sellOnlyViaAllocations = flags.getFlag(12)
        iDOR = flags.getFlag(13)
        dateCodeTrackingRequired = flags.getFlag(14)
        dateCodeIsSellByDate = flags.getFlag(15)
        isTapHandle = flags.getFlag(16)
        canSample = flags.getFlag(17)
        isPOS = flags.getFlag(18)
        requiresPOSNote = flags.getFlag(19)
        trackPOS = flags.getFlag(20)
        isDunnage = flags.getFlag(21)
        enableStoreLevelDatecodeRecording = flags.getFlag(22)
        isWine = flags.getFlag(23)
        isRedBull = flags.getFlag(24)
        isRawGoods = flags.getFlag(25)
        billingCodeAllowsPriceChanges = flags.getFlag(26)
        billingCodeIsForCredit = flags.getFlag(27)
        billingCodeIsForCharge = flags.getFlag(28)
        billingCodeIsWhilePreselling = flags.getFlag(29)
        billingCodeIsWhileDelivering = flags.getFlag(30)
        inventoryPOS = flags.getFlag(31)
        isGas = flags.getFlag(32)
        ignoresBrandFamilyCanBuyRestriction = flags.getFlag(33)
        isCraftBeer = flags.getFlag(34)
        isLiquor = flags.getFlag(35)
        activeFlag = flags.getFlag(36)
        billingCodeIsForCustomerWeb = flags.getFlag(37)

        altPackNids = record.getString(13).asRecNids(separatedBy: ",")
        altPackFamilyNid = record.getRecNidOrNil(14) ?? itemNid

        altPackSequence = record.getInt(15)
        altPackCasecount = record.getInt(16)
        altPackIsFractionOfPrimaryPack = record.getBool(17)
        priceBasisNid = record.getRecNidOrNil(18)
        weightOrMeasure = record.getScaledDouble(19, scale: 1000)
        warehouseLevel = record.getInt(20)
        qtyBought_NotReceived = record.getInt(21)
        truckLevel = record.getInt(22)
        loadedCost = record.getAmount4OrNil(23)
        defaultPriceEffectiveDate = record.getDateOrNil(24)
        defaultPrice2EffectiveDate = record.getDateOrNil(25)
        defaultPricePrior = record.getAmount4OrNilIfNegativeOne(26)
        defaultPrice2 = record.getAmount4OrNilIfNegativeOne(27)
        record.skipOneField()
        // var obsolete_PType = record.getInt(28)
        gallonsPerCase = record.getScaledDouble(29, scale: 10000)
        onHand = record.getInt(30)
        committed = record.getInt(31)
        productClassNid = record.getRecNidOrNil(32)
        retailUPC = record.getString(33)
        defaultReturnReasonNid = record.getRecNidOrNil(34)
        itemDeliverySequence = record.getInt(35)
        supplierDeposit = record.getAmount4OrNil(36)

        stockLocation = record.getString(37)
        backStockLocation = record.getString(38)
        itemPickSeq = record.getInt(39)
        nbrPrimaryPacks = record.getScaledDouble(40, scale: 10000)
        packsPerCase = record.getInt(41)
        fullDescription = record.getString(42)
        crvContainerTypeNid = record.getRecNidOrNil(43)
        unitsPerPack = record.getInt(44)
        wineAppellationNid = record.getRecNidOrNil(45)
        wineCharacterNid = record.getRecNidOrNil(46)
        wineClassificationNid = record.getRecNidOrNil(47)
        wineColorNid = record.getRecNidOrNil(48)
        countryNid = record.getRecNidOrNil(49)
        wineRegionNid = record.getRecNidOrNil(50)
        wineTypeNid = record.getRecNidOrNil(51)
        wineVarietalNid = record.getRecNidOrNil(52)
        wineScore1 = record.getString(53)
        wineScore2 = record.getString(54)
        wineVintage = record.getString(55)
        primarySupNid = record.getRecNidOrNil(56)
        dexPackType = eDEXPackName(rawValue: record.getInt(57)) ?? .NONE
        caseUPC = record.getString(58)
        containerNid = record.getRecNidOrNil(59)
        companyNid = record.getRecNidOrNil(60)
        cokePackSize = record.getString(61)
        cokeSalesUnit = record.getString(62)
        closeDateLevel = record.getInt(63)
        dateCodeLabelFormat = eDateCodeLabelFormat(rawValue: record.getInt(64)) ?? .None
        casesPerLayer = record.getInt(65)
        casesPerLayerEntries = Self.decodeCasesPerLayerEntries(blob: record.getString(66))
        litersPerCase = record.getScaledDouble(67, scale: 10000)
        addedTime = record.getDateOrNil(68)
        length = record.getScaledDouble(69, scale: 100)
        width = record.getScaledDouble(70, scale: 100)
        height = record.getScaledDouble(71, scale: 100)
        shelfPrice = record.getAmount4OrNil(72)

        if !depositIsSupplierOriginated {
            supplierDeposit = nil
        }
        if altPackFamilyNid == 0 {
            altPackFamilyNid = recNid
        }
        if altPackCasecount == 0 {
            altPackCasecount = 1
        }
        if fullDescription.isEmpty {
            fullDescription = recName
        }
        if !depositIsSupplierOriginated {
            supplierDeposit = nil
        }
        if litersPerCase == 0 { // LitersPerCase might not be populated, even if it is the desired field.
            litersPerCase = gallonsPerCase * 3.78541 // GallonsPerCase will always be populated, but risks rounding/conversion error.
        }
    }
    /// Decode the download "blob" of entries - "2,7;10,10" means if palletSizeNid==2, then qtyPerLayer=7; if palletSizeNid==10 then qtyPerLayer = 10
    static func decodeCasesPerLayerEntries(blob: String) -> [CasesPerLayer]? {
        if blob.isEmpty {
            return nil
        }

        var entries: [CasesPerLayer] = []
        for entry in blob.components(separatedBy: ";") {
            let pair = entry.components(separatedBy: ",")
            if pair.count == 2, let palletSizeNid = Int(pair[0]), palletSizeNid > 0, let casesPerLayer = Int(pair[1]) {
                entries.append(CasesPerLayer(palletSizeNid: palletSizeNid, casesPerLayer: casesPerLayer))
            }
        }

        if entries.isEmpty {
            return nil
        }

        return entries
    }

}
