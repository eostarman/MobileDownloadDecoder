import MobileDownload

import Foundation

extension CustomerRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        let recNid = record.getRecNidOrZero(0)
        self.recNid = recNid
        recKey = record.getString(1)
        recName = record.getString(2)
        salesChannelNid = record.getRecNidOrNil()
        geographicAreaNid = record.getRecNidOrNil()
        chainNid = record.getRecNidOrNil()
        taxAreaNid = record.getRecNidOrNil()
        pricingParentNid = record.getRecNidOrNil() ?? recNid

        whseNid = record.getWhseNid()
        holdCodeNid = record.getRecNidOrNil()
        PaymentTermsNid = record.getRecNidOrNil()

        shipAdr1 = record.getString()
        shipAdr2 = record.getString()
        shipAdr3 = record.getString()
        specialPrices = CusSpecialPricesDecoder.decodeSpecialPrices(blob: record.getString())
        encodedCusItemSales = record.getString() // aka itemHistoryBlob
        _ = record.getString() // obsolete_NextCallDates
        driverNid = record.getRecNidOrNil()
        offInvoiceDiscPct = record.getInt()

        var flags = EncodedFlags(flags: record.getString())

        isTaxable = flags.getFlag(0)
        _ = flags.getFlag(1) // zzzisCharge
        isDistributor = flags.getFlag(2)
        _ = flags.getFlag(3) // zzzisEFT
        requiresPONumber = flags.getFlag(4)
        doSerializedInventoryCountFlag = flags.getFlag(5)
        noPreloadOfHHInvoicesFromHistoryFlag = flags.getFlag(6)
        formatChar = String(flags.getFlagCharacter(7))
        doNotChargeDeposits = flags.getFlag(8)
        printBarcodesOnHHInvoicesFlag = flags.getFlag(9)
        printUpcInsteadOfRecKeyOnHHFlag = flags.getFlag(10)
        isWholesaler = flags.getFlag(11)
        _ = flags.getFlag(12) // zzzisCharge2
        _ = flags.getFlag(13) // zzzisEFT2
        _ = flags.getFlag(14) // zzzconsiderPaymentTerms2
        isPartitionedOnPaymentTerms = flags.getFlag(15)
        productClassBit1 = flags.getFlag(16)
        productClassBit2 = flags.getFlag(17)
        productClassBit3 = flags.getFlag(18)
        productClassBit4 = flags.getFlag(19)
        productClassBit5 = flags.getFlag(20)
        isBulkOrderFlag = flags.getFlag(21)
        forceUseOfBuildTo = flags.getFlag(22)
        mayBuyStrongBeer = flags.getFlag(23)
        idor = flags.getFlag(24)
        isFiveDigitEmpNids = flags.getFlag(25)
        isOffPremise = flags.getFlag(26)
        isOffScheduleCustomer = flags.getFlag(27)
        pONumberIsRecordedByDriver = flags.getFlag(28)
        customerBuysAlcohol = flags.getFlag(29)
        doNotChargeDunnageDeposits = flags.getFlag(30)
        isDEXCustomer = flags.getFlag(31)
        returnsOnSeparateInvoice = flags.getFlag(32)
        doNotChargeCarrierDeposits = flags.getFlag(33)
        chargeOnlySupplierDeposits = flags.getFlag(34)
        mayBuyWine = flags.getFlag(35)
        doNotAllowCODOverride = flags.getFlag(36)
        isCoop = flags.getFlag(37)
        productClassBit6 = flags.getFlag(38)
        productClassBit7 = flags.getFlag(39)
        productClassBit8 = flags.getFlag(40)
        productClassBit9 = flags.getFlag(41)
        productClassBit10 = flags.getFlag(42)
        isProspect = flags.getFlag(43)
        hasDraftBeer = flags.getFlag(44)
        rollAdditionalFeesIntoPrice = flags.getFlag(45)
        printPalletInfoOnInvoice = flags.getFlag(46)
        hasExpirationGracePeriod = flags.getFlag(47)
        isEligibleForTapSurveys = flags.getFlag(48)
        returnsPartitionerIgnoresBillingCodes = flags.getFlag(49)
        hasCustomerInvoiceFormatOverride = flags.getFlag(50)
        mayReceiveCloseDateProduct = flags.getFlag(51)
        hhInvoicesIgnoreItemSequence = flags.getFlag(52)
        doNotOptimizePallets = flags.getFlag(53)
        exemptFromCRVCharges = flags.getFlag(54)

        monthlySalesBlob = record.getString()

        standingOrderBlob = record.getString()
        hasCreditLimit = record.getBool()
        creditLimit = record.getAmount2()
        availableCredit = record.getAmount2()
        pastDueAmount = record.getAmount2()
        lastPaymentDate = record.getDateOrNil()

        totalFreight = record.getAmount2()
        hours = record.getString()
        orderNote = record.getString()
        standingPONum = record.getString()
        storeNum = record.getString()

        _ = record.getDateOrNil() // obsolete_schedStartDate
        _ = record.getInt() // obsolete_schedLength
        _ = record.getInt() // obsolete_schedMonday
        _ = record.getInt() // obsolete_schedTuesday
        _ = record.getInt() // obsolete_schedWednesday
        _ = record.getInt() // obsolete_schedThursday
        _ = record.getInt() // obsolete_schedFriday
        _ = record.getInt() // obsolete_schedSaturday
        _ = record.getInt() // obsolete_schedSunday
        _ = record.getDateOrNil() // obsolete_schedBlackoutFromDate
        _ = record.getDateOrNil() // obsolete_schedBlackoutThruDate

        isPresell = record.getBool()
        isTelsell = record.getBool()
        isOffTruck = record.getBool()
        isCustomerCallsUs = record.getBool()

        slsEmpNids = [Int](repeating: 0, count: 11)
        slsEmpNids[0] = record.getInt()

        numberOfAuthorizationListNids = record.getInt()
        authorizedItemListNids = [Int](repeating: 0, count: numberOfAuthorizationListNids)
        if numberOfAuthorizationListNids > 0 {
            for i in 0 ... numberOfAuthorizationListNids - 1 {
                authorizedItemListNids[i] = record.getInt()
            }
        }
        _ = record.getInt() // obsolete_schedPresellDaysInAdvance

        shelfSequenceNid = record.getRecNidOrNil()

        buildToLevelsBlob = record.getString()

        monthlySalesByItemBlob = record.getString()

        liquorLicenseNumber = record.getString()
        liquorLicenseExpirationDate = record.getDateOrNil()

        numberOfCustomerVisits = record.getInt()

        let fakeDate = Date()

        visitTime = [Date](repeating: fakeDate, count: numberOfCustomerVisits)
        visitNonServiceReasonRecName = [String](repeating: "", count: numberOfCustomerVisits)
        visitByEmployeeRecName = [String](repeating: "", count: numberOfCustomerVisits)
        visitByDescription = [String](repeating: "", count: numberOfCustomerVisits)

        if numberOfCustomerVisits > 0 {
            for k in 0 ..< numberOfCustomerVisits {
                visitTime[k] = record.getDateOrNil() ?? .distantPast
                visitNonServiceReasonRecName[k] = record.getString()
                visitByEmployeeRecName[k] = record.getString()
                visitByDescription[k] = record.getString()
            }
        }

        _ = record.getDateOrNil() // obsolete_schedStopDate
        _ = record.getDateOrNil() // obsolete_schedStopDate2
        _ = record.getDateOrNil() // obsolete_schedStartDate2
        _ = record.getInt() // obsolete_schedLength2
        _ = record.getInt() // obsolete_schedMonday2
        _ = record.getInt() // obsolete_schedTuesday2
        _ = record.getInt() // obsolete_schedWednesday2
        _ = record.getInt() // obsolete_schedThursday2
        _ = record.getInt() // obsolete_schedFriday2
        _ = record.getInt() // obsolete_schedSaturday2
        _ = record.getInt() // obsolete_schedSunday2

        _ = record.getInt() // obsolete_driverNid2
        _ = record.getInt() // obsolete_schedSundayDriverNid
        _ = record.getInt() // obsolete_schedSundayDriverNid2
        _ = record.getInt() // obsolete_schedMondayDriverNid
        _ = record.getInt() // obsolete_schedMondayDriverNid2
        _ = record.getInt() // obsolete_schedTuesdayDriverNid
        _ = record.getInt() // obsolete_schedTuesdayDriverNid2
        _ = record.getInt() // obsolete_schedWednesdayDriverNid
        _ = record.getInt() // obsolete_schedWednesdayDriverNid2
        _ = record.getInt() // obsolete_schedThursdayDriverNid
        _ = record.getInt() // obsolete_schedThursdayDriverNid2
        _ = record.getInt() // obsolete_schedFridayDriverNid
        _ = record.getInt() // obsolete_schedFridayDriverNid2
        _ = record.getInt() // obsolete_schedSaturdayDriverNid
        _ = record.getInt() // obsolete_schedSaturdayDriverNid2

        buildToCountsBlob = record.getString()

        cusDeliveryInstruction = record.getString()
        _ = record.getString() // obsolete_presellDaysInAdvanceOverride

        routeBookCounts = record.getString()

        arBalance = record.getAmount2()

        _ = record.getInt() // obsolete_PaymentTermsNid2

        let eventsBlob = record.getString()
        cusEvents = CusEventsDecoder.decodeCusEvents(eventsBlob: eventsBlob, isFiveDigitEmpNids: isFiveDigitEmpNids)

        deliveryChargeNid = record.getRecNidOrNil()

        brandFamilyAssignments = Set(record.getString().asRecNids(separatedBy: "b"))

        defaultOffDayDeliveryDriverNid = record.getRecNidOrNil()

        idorTaxableSales = record.getInt()

        bumpNote = record.getString()

        shipCity = record.getString()
        shipState = record.getString()
        shipZip = record.getString()

        totalDeliveryCharge = record.getAmount2()
        doNotChargeUnitDeliveryCharge = record.getBool()
        doNotChargeUnitFreight = record.getBool()

        retailPrices = CustomerRetailPricesDecoder.decodeRetailPrices(retailPricesBlob: record.getString())

        retailPricesAreReadOnly = record.getBool()

        cusPermits = CusPermitsDecoder.decodeCusPermits(cusNid: recNid, cusPermitBlob: record.getString())

        specialPaymentTerms = record.getString()

        qualifiedPromos = record.getString()

        retailPriceListNid = record.getRecNidOrNil()

        priceRuleNids = record.getString().asRecNids(separatedBy: ",")

        let shipLatitude = record.getDouble()
        let shipLongitude = record.getDouble()
        if shipLatitude != 0 || shipLongitude != 0 {
            self.shipLatitude = shipLatitude
            self.shipLongitude = shipLongitude
        }
        retailDateCodesBlob = record.getString()

        iDORtaxableSalesPrev = record.getInt()

        territoryNid = record.getRecNidOrNil()

        ediPartnerNid = record.getRecNidOrNil()

        uxSurveyNids = record.getString()

        posScheduledRemovals = record.getString()

        dexCommID = record.getString()
        dunsPlusFour = record.getString()
        locationNum = record.getString()

        blacklistedItems = Set(record.getString().asRecNids(separatedBy: "i"))

        hasStrictCreditLimitEnforcement = record.getBool()
        pendingOrderCreditBalance = record.getAmount2()

        liquorLicenseTo = record.getString()

        let retailerInfoBlob = record.getString()
        retailerInfo = RetailerInfoDecoder.decodeCustomerRetailerInfo(retailerInfoBlob: retailerInfoBlob)

        useSecondaryContainerDeposits = record.getBool()

        countHistoryBlob = record.getString()

        vendorID = record.getString()

        syrupTaxID = record.getString()

        poaBalance = record.getAmount2()
        poaAmount = record.getAmount2()

        numberOfSalesHistoryDays = record.getInt()
        deliveryChargePaymentTermNid = record.getRecNidOrNil()

        sinTaxSpecialHandling = record.getInt()
        eligibleForAutoCOD = record.getBool()

        deliveryWindow1Start = record.getString()
        deliveryWindow1End = record.getString()
        deliveryWindow2Start = record.getString()
        deliveryWindow2End = record.getString()

        bulkPalletSizeNid = record.getRecNidOrNil()

        countyNid = record.getRecNidOrNil()

        holdCodeNid2 = record.getRecNidOrNil()
        isNonRetail = record.getBool()

        stopEquipNidsBlob = record.getString()

        slsEmpNids[1] = record.getInt()
        slsEmpNids[2] = record.getInt()
        slsEmpNids[3] = record.getInt()
        slsEmpNids[4] = record.getInt()
        slsEmpNids[5] = record.getInt()
        slsEmpNids[6] = record.getInt()
        slsEmpNids[7] = record.getInt()
        slsEmpNids[8] = record.getInt()
        slsEmpNids[9] = record.getInt()
        slsEmpNids[10] = record.getInt()

        billingCodeHistoryBlob = record.getString()

        stateSalesTaxExemptCertNum = record.getString()
        stateSalesTaxExemptCertExpirationDate = record.getDateOrNil()
        countySalesTaxExemptCertNum = record.getString()
        countySalesTaxExemptCertExpirationDate = record.getDateOrNil()
        citySalesTaxExemptCertNum = record.getString()
        citySalesTaxExemptCertExpirationDate = record.getDateOrNil()
        localSalesTaxExemptCertNum = record.getString()
        localSalesTaxExemptCertExpirationDate = record.getDateOrNil()
        wholesaleSalesTaxExemptCertNum = record.getString()
        wholesaleSalesTaxExemptCertExpirationDate = record.getDateOrNil()

        // businessHourInfo
        openTimeRaw = record.getString()
        closeTimeRaw = record.getString()
        crossStreets = record.getString()
        isClosed = record.getBool()
        scheduleStatusNote = record.getString()
        deliveryWindowsOverrideBlob = record.getString()
        mobilePresellCutoffTimeOverride = record.getDateOrNil()
        scheduleActiveStatus = record.getInt() // (eScheduleActiveStatus)record.getInt()
        scheduleActiveFromDate = record.getDateOrNil()
        scheduleActiveThruDate = record.getDateOrNil()

        transactionCurrencyNid = record.getRecNidOrNil()

        standingPONumbers = record.getString()

        // --- all fields have been fetched abov
    }
}
