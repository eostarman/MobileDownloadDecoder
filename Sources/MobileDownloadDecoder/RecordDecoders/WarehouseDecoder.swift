import MobileDownload


import Foundation

extension WarehouseRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        shipAdr1 = record.getString(3)
        shipAdr2 = record.getString(4)
        shipCity = record.getString(5)
        shipState = record.getString(6)
        shipZip = record.getString(7)
        shipAdr3 = record.getString(8)
        whseAreasBlob = record.getString(9)
        kegDeposit = record.getAmount2(10)
        shipLatitude = record.getDoubleOrNil(11)
        shipLongitude = record.getDoubleOrNil(12)
        defaultOffDayDeliveryDriverNidString = record.getInt(13)
        noSellDaysBlob = record.getString(14)
        hasKegDeposit = record.getBool(15)
        companyNid = record.getRecNidOrNil(16)
        vendProductSetNid = record.getRecNidOrNil(17)
        warehouseInventoryAvailabilityBlob = record.getString(18)
        palletOptimizationCoreItemsBlob = record.getString(19)
        onOrderBlob = record.getString(20)
        palletOptimizationUseLayerPickRounding = record.getBool(21)
        palletOptimizationUsePercentCompleteLayerRounding = record.getBool(22)
        palletOptimizationUsePackageFillLayerRounding = record.getBool(23)
        layerRoundingPercentCompleteMinimum = record.getScaledDecimal(24, scale: 2)
        layerRoundingPackageFillPercentMinimum = record.getScaledDecimal(25, scale: 2)
        percentCompleteItemsBlob = record.getString(26)
        palletOptimizationLayerFillerItems = record.getString(27)
        nextDayDeliveryCutoffTime = record.getString(28)
        nextDayDeliveryCutoffWarningWindowInMinutes = record.getInt(29)
        allowMobileHotShotRequests = record.getBool(30)
        sellableItemsProductSetNid = record.getRecNidOrNil(31)
        truckReplenSettingsBlob = record.getString(32)
        inMarketSameProduct = record.getBool(33)
        warehouseSellabilityOverrides = Self.decodeWarehouseSellabilityOverrides(record.getString(34))
    }

    static func decodeWarehouseSellabilityOverrides(_ blob: String) -> [WarehouseSellabilityOverride] {
        var overrides: [WarehouseSellabilityOverride] = []

        if blob.isEmpty {
            return overrides
        }

        for entry in blob.components(separatedBy: ";") {
            if entry.isEmpty {
                continue
            }

            let fields = entry.components(separatedBy: ",")

            var override = WarehouseSellabilityOverride()
            override.whseNid = Int(fields[0]) ?? 0
            override.itemNid = Int(fields[1]) ?? 0
            override.canBuy = fields[2] == "1"
            override.canIssue = fields[3] == "1"
            override.canSell = fields[4] == "1"
            override.canSample = fields[5] == "1"

            overrides.append(override)
        }

        return overrides
    }
}
