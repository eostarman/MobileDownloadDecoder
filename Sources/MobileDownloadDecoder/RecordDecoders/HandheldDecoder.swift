import MobileDownload
import MoneyAndExchangeRates

import Foundation

extension HandheldRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        var flags = EncodedFlags(flags: record.getString(3))

        handheldEmpNid = record.getRecNidOrZero(4)
        routeWhseNid = record.getRecNidOrZero(5)
        record.skip(numberOfFields: 19)
        // self.obsolete_FirstTicketNumber = record.getInt(6)
        // self.obsolete_LastTicketNumber = record.getInt(7)
        // self.obsolete_NextTicketNumber = record.getInt(8)
        // self.obsolete_schedule0Date = record.getDate(9)
        // self.obsolete_schedule0CusNids = record.getString(10)
        // self.obsolete_schedule1Date = record.getDate(11)
        // self.obsolete_schedule1CusNids = record.getString(12)
        // self.obsolete_schedule2Date = record.getDate(13)
        // self.obsolete_schedule2CusNids = record.getString(14)
        // self.obsolete_schedule3Date = record.getDate(15)
        // self.obsolete_schedule3CusNids = record.getString(16)
        // self.obsolete_schedule4Date = record.getDate(17)
        // self.obsolete_schedule4CusNids = record.getString(18)
        // self.obsolete_schedule5Date = record.getDate(19)
        // self.obsolete_schedule5CusNids = record.getString(20)
        // self.obsolete_schedule6Date = record.getDate(21)
        // self.obsolete_schedule6CusNids = record.getString(22)
        // self.obsolete_schedule7Date = record.getDate(23)
        // self.obsolete_schedule7CusNids = record.getString(24)
        nbrPriceDecimals = record.getInt(25)
        trkNid = record.getRecNidOrNil(26)
        fromYear = record.getInt(27)
        thruYear = record.getInt(28)

        let availableTicketNumbersBlob = record.getString(29) // "1765634,1765798O1773399,1773598O1094000,1094199I1094200,1094399I"
        availableOrderNumbers = Self.decodeAvailableOrderOrItemTransferNumbers(blob: availableTicketNumbersBlob, lookingFor: "O")
        availableItemTransferNumbers = Self.decodeAvailableOrderOrItemTransferNumbers(blob: availableTicketNumbersBlob, lookingFor: "I")

        record.skip(numberOfFields: 2)
        // self.obsolete_presellOneDayInAdvanceSettings = record.getString(30)
        // self.obsolete_presellTwoDayInAdvanceSettings = record.getString(31)

        let invoiceHeaderLine1 = record.getString(32)
        let invoiceHeaderLine2 = record.getString(33)
        let invoiceHeaderLine3 = record.getString(34)
        let invoiceHeaderLine4 = record.getString(35)
        let invoiceHeaderLine5 = record.getString(36)
        let invoiceHeaderLine6 = record.getString(37)
        let invoiceHeaderLine7 = record.getString(38)
        let invoiceHeaderLine8 = record.getString(39)
        let invoiceHeaderLine9 = record.getString(40)
        let invoiceHeaderLine10 = record.getString(41)
        invoiceHeader = String(fromLines: invoiceHeaderLine1, invoiceHeaderLine2, invoiceHeaderLine3, invoiceHeaderLine4, invoiceHeaderLine5,
                               invoiceHeaderLine6, invoiceHeaderLine7, invoiceHeaderLine8, invoiceHeaderLine9, invoiceHeaderLine10)

        let advertisementLine1 = record.getString(42)
        let advertisementLine2 = record.getString(43)
        let advertisementLine3 = record.getString(44)
        let advertisementLine4 = record.getString(45)
        let advertisementLine5 = record.getString(46)
        let advertisementLine6 = record.getString(47)
        let advertisementLine7 = record.getString(48)
        let advertisementLine8 = record.getString(49)
        let advertisementLine9 = record.getString(50)
        let advertisementLine10 = record.getString(51)
        advertisement = String(fromLines: advertisementLine1, advertisementLine2, advertisementLine3, advertisementLine4, advertisementLine5, advertisementLine6, advertisementLine7, advertisementLine8, advertisementLine9, advertisementLine10)

        record.skip(numberOfFields: 7)
        // self.obsolete_sundayCusNids = record.getString(52)
        // self.obsolete_mondayCusNids = record.getString(53)
        // self.obsolete_tuesdayCusNids = record.getString(54)
        // self.obsolete_wednesdayCusNids = record.getString(55)
        // self.obsolete_thursdayCusNids = record.getString(56)
        // self.obsolete_fridayCusNids = record.getString(57)
        // self.obsolete_saturdayCusNids = record.getString(58)

        driverPreorder = record.getString(59)
        maxTransactionDaysOut = record.getInt(60)
        defaultOffDayDeliveryDriverNid = record.getRecNidOrNil(61)
        invoiceLogoNid = record.getRecNidOrNil(62)
        nonReturnablesProductSetNid = record.getRecNidOrNil(63)
        nonReturnablesOverridePassword = record.getString(64)
        rutherfordDatabaseNumber = record.getString(65)
        nonReturnablesPresellProductSetNid = record.getRecNidOrNil(66)
        nonReturnablesPresellOverridePassword = record.getString(67)
        posRemovalsOrderTypeNid = record.getRecNidOrNil(68)
        liquorLicenseWarningDays = record.getInt(69)
        storeLevelDatecodeThresholdInDays = record.getInt(70)
        presellProductSetNid = record.getRecNidOrNil(71)
        vendProductSetNid = record.getRecNidOrNil(72)
        whseDuns = record.getString(73)
        dexCommID = record.getString(74)
        locationNum = record.getString(75)
        sigKey = record.getInt(76)
        reportsToEmpNids = record.getString(77).asRecNids(separatedBy: ",")
        actualEmpNid = record.getRecNidOrZero(78)
        routeEmpNid = record.getRecNidOrZero(79)
        syncSessionNid = record.getRecNidOrNil(80)
        rawSyncTimestampWithoutTimezone = record.getString(81)
        otlDeliveryAdjustmentNid = record.getRecNidOrNil(82)
        webOrderTypeNid = record.getRecNidOrNil(83)
        defaultPaymentCompanyNid = record.getRecNidOrNil(84)
        liquorLicenseExpirationGracePeriod = record.getInt(85)

        let companyItemsBlob = record.getString(86)
        companyItems = Self.decodeCompanyItemEntries(fromBlob: companyItemsBlob)

        extendedReturnReasonCutoffDays = record.getInt(87)
        dEXRemovalReason = record.getInt(88)
        topDunnageItemNids = record.getString(89).asRecNids(separatedBy: ",")
        numberOfSalesHistoryDays = record.getInt(90)
        defaultMisPickAdjustmentReasonNid = record.getRecNidOrNil(91)
        softeonDeliveryAdjustmentReasonNid = record.getRecNidOrNil(92)
        truckBays = record.getString(93).components(separatedBy: ",")
        autoCODPaymentTermsEnabled = record.getBool(94)
        autoCODPaymentTermsNid = record.getRecNidOrNil(95)
        autoCODPastDueDays = record.getInt(96)
        autoCODMinPastDue = record.getAmount4(97)
        autoCutDuringOrderEntry = record.getBool(98)
        appVersion = record.getString(99)
        eoNetServiceVersion = record.getString(100)
        databaseVersion = record.getString(101)
        autoCutExclusionProductSetNid = record.getRecNidOrNil(102)
        walkaroundCountCutoffDate = record.getDateOrNil(103)
        directSwapOrderTypeNid = record.getRecNidOrNil(104)
        autoIncludeCreditsInDeliverStop = record.getBool(105)
        autoIncludeCreditsCustomerSetNid = record.getRecNidOrNil(106)
        autoIncludeCreditsMaxAmount = record.getAmount2(107)
        autoIncludePastDueARFromDeliverStop = record.getBool(108)
        autoIncludePastDueARCustomerSetNid = record.getRecNidOrNil(109)
        inMarketOrderTypeNid = record.getRecNidOrNil(110)
        customerWebLoginNid = record.getRecNidOrNil(111)
        explicitCusNidsForCustomerWeb = record.getString(112).asRecNids(separatedBy: ",")
        customerWebEmail = record.getString(113)
        customerWebPassword = record.getString(114)
        rawSyncTimestampWithTimezone = record.getString(115)
        requireAuthorizationForDeliveryAdjustmentsAboveThreshold = record.getBool(116)
        deliveryAdjustmentAuthorizationThreshold = record.getInt(117)
        vendReturnDamagedItemWriteoffNid = record.getRecNidOrNil(118)
        vendReturnOutOfDateItemWriteoffNid = record.getRecNidOrNil(119)
        truckRecKeys = record.getString(120).asArrayWithoutFinalEmptyEntry(separatedBy: ",")
        noTrailerTruckRecKeys = record.getString(121).asArrayWithoutFinalEmptyEntry(separatedBy: ",")

        serviceRequirePartsField = record.getBool(122)
        serviceRequireProcedureField = record.getBool(123)
        serviceRequireNoteField = record.getBool(124)
        serviceRequireSystemField = record.getBool(125)
        serviceRequireSubsystemField = record.getBool(126)
        defaultCurrencyNid = record.getRecNidOrNil(127)
        exchangeRates = decodeExchangeRates(exchangeRatesBlob: record.getString(128))

        routeType = eRouteType(rawValue: record.getInt(129)) ?? .Regular

        activeFlag = flags.getFlag(0)
        isWarehouse = flags.getFlag(1)
        isDelivery = flags.getFlag(2)
        requiresDepositsSupport = flags.getFlag(3)
        _ = flags.getFlag(4) // requiresPresellDaysInAdvanceSupport
        _ = flags.getFlag(5) // requiresEFTSupport
        printTaxBreakdownOnHandheldInvoices = flags.getFlag(6)
        printARBalanceOnHandheldInvoices = flags.getFlag(7)
        requiresScheduleSupport = flags.getFlag(8)
        requiresRouteBookSupport = flags.getFlag(9)
        requiresBeerWinePluginSupport = flags.getFlag(10)
        useQtyOrderedForPricingAndPromos = flags.getFlag(11)
        autoSetDriverBasedOnDate = flags.getFlag(12)
        requiresAllocationSupport = flags.getFlag(13)
        useCombinedOrderEntryForm = flags.getFlag(14)
        isIllinoisTaxPluginInstalled = flags.getFlag(15)
        useItemDeliverySequence = flags.getFlag(16)
        mtdytd_IsCaseEquiv = flags.getFlag(17)
        supportBackorderedPurchases = flags.getFlag(18)
        _ = flags.getFlagCharacter(19) // nextTransferStepFlag
        _ = flags.getFlagCharacter(20) // nextPurchaseStepFlag
        isOhioTaxPluginInstalled = flags.getFlag(21)
        requireDateCodesWhenCountingWarehouse = flags.getFlag(22)
        enforceRestoreCode = flags.getFlag(23)
        mobilePresellersCanSchedulePickups = flags.getFlag(24)
        requiresPOSSupport = flags.getFlag(25)
        requireDriverSignature = flags.getFlag(26)
        hH_COD_PaymentRequired = flags.getFlag(27)
        _ = flags.getFlag(28) // allowDiscountOnlyOrderLines
        isGoalsPluginInstalled = flags.getFlag(29)
        downloadGoalsAtFullsync = flags.getFlag(30)
        downloadAllDataForOffScheduleCustomers = flags.getFlag(31)
        includeCommonCarrierShipments = flags.getFlag(32)
        enableStoreLevelDatecodeRecording = flags.getFlag(33)
        isCaliforniaTaxPluginInstalled = flags.getFlag(34)
        isTruckInspectionPluginInstalled = flags.getFlag(35)
        isUxPluginInstalled = flags.getFlag(36)
        handheldShowDollarsForInvoiceReview = flags.getFlag(37)
        handheldEnforceBeginOfDayTruckInsp = flags.getFlag(38)
        isUserPeerlessPluginInstalled = flags.getFlag(39)
        printLocationOnStripTruck = flags.getFlag(40)
        isUserJJTaylorPluginInstalled = flags.getFlag(41)
        useSellDaysForDeliveries = flags.getFlag(42)
        wineBottleReatilUPC = flags.getFlag(43)
        isObjectivesPluginInstalled = flags.getFlag(44)
        isAllied = flags.getFlag(45)
        requiresAdAlertSupport = flags.getFlag(46)
        noRedBullSalesToOffPremiseAccounts = flags.getFlag(47)
        driversSeeDeliveriesOnly = flags.getFlag(48)
        isWineByTheGlassPluginInstalled = flags.getFlag(49)
        requireDeliveryVoidCode = flags.getFlag(50)
        useExtendedReturnReasonDialog = flags.getFlag(51)
        isCoopPluginInstalled = flags.getFlag(52)
        handheldLeftOnTruckDefault = flags.getFlag(53)
        _ = flags.getFlag(54) // handheldCheckOrderPartitionsOnDelivery
        considerOffTruckInDeliverySchedule = flags.getFlag(55)
        isMultiCompanyPluginInstalled = flags.getFlag(56)
        multiCompanyByWarehouse = flags.getFlag(57)
        uploadAfterDelivery = flags.getFlag(58)
        isVendingPluginInstalled = flags.getFlag(59)
        isTaxSchedulePluginInstalled = flags.getFlag(60)
        requireTruckAndTrailerNumber = flags.getFlag(61)
        hhPicklistsGroupByPackage = flags.getFlag(62)
        isCokePluginInstalled = flags.getFlag(63)
        isBackorderPluginInstalled = flags.getFlag(64)
        promoRebatesSupercedeSupplierRebates = flags.getFlag(65)
        purchasesAreProducedInHouse = flags.getFlag(66)
        requireTapSurveyForOnPremiseBeerCustomers = flags.getFlag(67)
        useDeliverStopForMultiInvoiceCustomers = flags.getFlag(68)
        partitionOffTruckOrders = flags.getFlag(69)
        useRestockReturnReason = flags.getFlag(70)
        supplierCostIsNotWholesalerPrice = flags.getFlag(71)
        isQtyVendedBasedOnFills = flags.getFlag(72)
        neverUseHistoricalPriceForReturns = flags.getFlag(73)
        preserveQuotedDiscountsAfterPartitioning = flags.getFlag(74)
        printDeliveryDiscrepanciesOnHandheldInvoices = flags.getFlag(75)
        isSyrupTaxPluginInstalled = flags.getFlag(76)
        vendDriversNotScheduledForVendingMayEnterVendTickets = flags.getFlag(77)
        printMergeAutoLinesOnHandheldInvoices = flags.getFlag(78)
        isAutoBumpPluginInstalled = flags.getFlag(79)
        isC2CPluginInstalled = flags.getFlag(80)
        c2cTracksDistributionByDateOnly = flags.getFlag(81)
        isActionItemsPluginInstalled = flags.getFlag(82)
        isCloseDatePluginInstalled = flags.getFlag(83)
        strictLiquorLicenseEnforcement = flags.getFlag(84)
        extendedReturnReasonChooseLowestPrice = flags.getFlag(85)
        requireDateCodesForReturns = flags.getFlag(86)
        requireDateCodesForReturns_DriverValidationRequired = flags.getFlag(87)
        isDateCodePluginInstalled = flags.getFlag(88)
        forcePrCEPrinting = flags.getFlag(89)
        sortInvoiceByPalletSeq = flags.getFlag(90)
        mandatorySurveysCompletedAfterOrderHandling = flags.getFlag(91)
        isAndrewsPluginInstalled = flags.getFlag(92)
        handheldEnforceEndOfDayTruckInsp = flags.getFlag(93)
        isNewJerseyTaxPluginInstalled = flags.getFlag(94)
        enablePOA = flags.getFlag(95)
        isBeverageTaxPluginInstalled = flags.getFlag(96)
        doNotUseQtyOrderedForBuyXGetY = flags.getFlag(97)
        groupScansheetByPackage = flags.getFlag(98)
        uploadPresellAfterSave = flags.getFlag(99)
        requireCheckInReturnValidation = flags.getFlag(100)
        requireSignaturesForStripTruck = flags.getFlag(101)
        driversMustHandleAllDeliveriesBeforeSync = flags.getFlag(102)
        useReceivableGroups = flags.getFlag(103)
        notesRequireDriverReview = flags.getFlag(104)
        includeBillingCodesInTermsPartitioning = flags.getFlag(105)
        cuyahogaSpecialHandling = flags.getFlag(106)
        isRetailerPluginInstalled = flags.getFlag(107)
        handheldPalletBreakdownScansheet = flags.getFlag(108)
        netServiceSupportsPostingCustomerNoteEdits = flags.getFlag(109)
        isMetric = flags.getFlag(110)

        // bShelfLabelPrintingEnabled = rutherfordDatabaseNumber == "FL-1065-108" || rutherfordDatabaseNumber == "FL-1065-1082"  // JJ Tampa or JJ Minnesota
        // bPrintBTLColumnOnInvoice = rutherfordDatabaseNumber.StartsWith("MT-1720")  // BRIGGS,
        // bPrintDoNotPayOnReviewInvoices = true    // PER THU ALWAYS DO THIS ... based on survey of customers

        func getSyncTime() -> Date {
            let dateString = !rawSyncTimestampWithTimezone.isEmpty ? rawSyncTimestampWithTimezone : rawSyncTimestampWithoutTimezone
            let date = Date.fromDownloadedDateOrDateTime(dateString)
            return date ?? Date()
        }

        syncTime = getSyncTime()
        syncDate = syncTime.withoutTimeStamp()
    }

    private func decodeExchangeRates(exchangeRatesBlob: String) -> ExchangeRatesService {
        if exchangeRatesBlob.isEmpty {
            return ExchangeRatesService.cachedExchangeRatesService
        }

        let tuples = exchangeRatesBlob.components(separatedBy: "|") // see CommonTypes/ExchangeRates.cs
        var exchangeRates: [ExchangeRate] = []
        let effectiveDate = syncDate

        for tuple in tuples {
            let parts = tuple.components(separatedBy: ",")
            guard parts.count == 3 else {
                continue
            }
            if let fromCurrencyNid = Int16(parts[0]),
               let toCurrencyNid = Int16(parts[1]),
               let rate = Double(parts[2]),
               let fromCurrency = Currency(rawValue: fromCurrencyNid),
               let toCurrency = Currency(rawValue: toCurrencyNid)
            {
                if rate > 0 {
                    exchangeRates.append(ExchangeRate(from: fromCurrency, to: toCurrency, date: effectiveDate, rate: rate))
                }
            }
        }
        if exchangeRates.isEmpty {
            return ExchangeRatesService.cachedExchangeRatesService
        }
        return ExchangeRatesService(exchangeRates)
    }

    static func decodeCompanyItemEntries(fromBlob: String) -> [CompanyItem] {
        if fromBlob.isEmpty {
            return []
        }

        var companyItems: [CompanyItem] = []
        let tuples = fromBlob.components(separatedBy: ";")
        for tuple in tuples {
            let parts = tuple.components(separatedBy: ",")
            let hostWhseNid = parts[0].asRecNid
            let productSetNid = parts[1].asRecNid
            if let companyNid = parts[2].asRecNid {
                var companyItem = CompanyItem()
                companyItem.companyNid = companyNid
                companyItem.hostWhseNid = hostWhseNid
                companyItem.productSetNid = productSetNid

                companyItems.append(companyItem)
            }
        }
        return companyItems

        // "0,0,1;1,0,1;2,0,1;3,0,1;4,0,1;5,0,5;6,0,1;7,0,3;8,0,1;9,0,1;10,0,1;11,0,4;12,0,4;13,0,4;14,0,4;15,0,4;16,0,4;17,0,4;18,0,4;19,0,4;20,0,1;21,0,1;22,0,1;23,0,1;24,0,2;25,0,3;26,0,3;27,0,1;29,0,1;0,9,1;0,16,2;0,1203,5;0,1209,3;1,9,1;3,9,1;6,9,1;7,9,1;8,9,1;9,9,1;21,9,1;22,9,1;23,9,1;25,9,1;26,9,1;27,9,1;29,9,1;1,16,2;6,16,2;8,16,2;24,16,2;27,16,2;29,16,2;5,1203,5;6,1203,1;8,1203,1;23,1203,1;6,1209,3;7,1209,3;8,1209,3;9,1209,3;23,1209,3;25,1209,3;26,1209,3;27,1209,3;29,1209,3;6,1384,3;7,1384,3;8,1384,3;9,1384,3;23,1384,3;25,1384,3;26,1384,3;27,1384,3;29,1384,3;26,16,2"
    }

    /// Return the ticket numbers from the downloaded ranges. The ranges are followed by "O" (for orders) or "I" (for item transfers). So, when you create a new order to be signed
    /// you should use one of the available order numbers that were transmitted from eoStar to this handheld (then when we upload the deliveries, they won't be re-numbered)
    /// - Parameters:
    ///   - blob: the encoded ranges - e.g. "12721406,12721599O12795000,12795199O1313774,1313799I1352000,1352199I"
    ///   - lookingFor: "O" for orders or "I" for item transfers
    /// - Returns: an array or available ticket numbers
    static func decodeAvailableOrderOrItemTransferNumbers(blob: String, lookingFor: Character) -> [Int] {
        if blob.isEmpty {
            return []
        }

        var ticketNumbers: [Int] = []

        var from: Int?
        var thru: Int?
        var temp: Int = 0
        for chr in blob {
            if let digit = chr.wholeNumberValue {
                temp = temp * 10 + digit
            } else if chr == "," {
                from = temp
                temp = 0
            } else {
                thru = temp
                temp = 0

                if chr == lookingFor {
                    if var from = from, let thru = thru {
                        while from <= thru {
                            ticketNumbers.append(from)
                            from += 1
                        }
                    }
                }

                from = nil
                thru = nil
            }
        }

        return ticketNumbers
    }
}
