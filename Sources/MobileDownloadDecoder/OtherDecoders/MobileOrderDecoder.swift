//
//  MobileOrderParser.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 8/31/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

extension MobileDownloadDecoderService {
    /// Parse the serialized MobileOrder that's downloaded in MobileDownload; it's a custom token-serialization
    static func decodeMobileOrder(blob: String) -> MobileOrder {
        // TODO: line.UnitCRV = databaseCache.GetItemCRV(CustomerInfo, databaseCache.GetItemInfo(line.ItemNid), order.OrderTypeNid);
        // TODO: case eToken.VAT:
        // TODO: case eToken.Levy:

        var retailPrice: MoneyWithoutCurrency = .zero
        var buildTo: Int?
        var count: Decimal?
        var routeBookBuildTo: Decimal?
        var editedRetailPrice: Bool = false
        var itemNameOverride: String?
        var qtyOrdered: Int = 0
        var qtyShipped: Int = 0
        var qtyDiscounted: Int?
        var qtyBackordered: Int = 0
        var qtyDeliveryDriverAdjustment: Int = 0
        var qtyLayerRoundingAdjustment: Int = 0 // qtyPalletOptimizationAdjustment
        var crvContainerTypeNid: Int = 0
        var unitPrice: MoneyWithoutCurrency = .zero
        var unitDisc: MoneyWithoutCurrency = .zero
        var unitSplitCaseCharge: MoneyWithoutCurrency = .zero
        var unitDeposit: MoneyWithoutCurrency = .zero
        var carrierDeposit: MoneyWithoutCurrency = .zero
        var bagCredit: MoneyWithoutCurrency = .zero
        var statePickupCredit: MoneyWithoutCurrency = .zero
        var unitFreight: MoneyWithoutCurrency = .zero
        var unitDeliveryCharge: MoneyWithoutCurrency = .zero
        var pickAndShipDateCodes: String?
        var dateCode: Date?
        var originalQtyShipped: Int?
        var originalItemWriteoffNid: Int?
        var uniqueifier: Int = 0
        var wasDownloaded: Bool = false
        var itemWriteoffNid: Int = 0
        var promo1Nid: Int = 0
        var wasAutoCut: Bool = false
        var isCloseDatedInMarket: Bool = false
        var isManualPrice: Bool = false
        var isManualDiscount: Bool = false
        var isManualDeposit: Bool = false
        var basePricesAndPromosOnQtyOrdered: Bool = false

        var mergeSequenceTag: Int?
        var autoFreeGoodsLine: Bool = false
        var isPreferredFreeGoodLine: Bool = false
        var parentOrderedDate: Date?
        var parentSlsEmpNid: Int?
        var CMAOnNid: Int?
        var CTMOnNid: Int?
        var CCFOnNid: Int?
        var CMAOffNid: Int?
        var CTMOffNid: Int?
        var CCFOffNid: Int?
        var CMAOnAmt: MoneyWithoutCurrency = .zero
        var CTMOnAmt: MoneyWithoutCurrency = .zero
        var CCFOnAmt: MoneyWithoutCurrency = .zero
        var CMAOffAmt: MoneyWithoutCurrency = .zero
        var CTMOffAmt: MoneyWithoutCurrency = .zero
        var CCFOffAmt: MoneyWithoutCurrency = .zero
        var commOverrideSlsEmpNid: Int?
        var commOverrideDrvEmpNid: Int?
        var qtyCloseDateRequested: Int?
        var qtyCloseDateShipped: Int?
        var qtyShippedWhenVoided: Int?
        var preservePricing: Bool = false
        var noteLink: Int = 0

        func getOrderLine(itemNid: Int, seq: Int) -> MobileOrderLine {
            let line = MobileOrderLine()

            let qtyDiscountedOnThisLine: Int?

            if promo1Nid == 0 || unitDisc.isZero {
                qtyDiscountedOnThisLine = nil
            } else {
                if qtyDiscounted != nil {
                    qtyDiscountedOnThisLine = qtyDiscounted
                } else {
                    qtyDiscountedOnThisLine = qtyShipped
                }
            }

            line.promo1Nid = promo1Nid
            line.qtyDiscounted = qtyDiscounted ?? 0
            line.unitDisc = unitDisc
            line.isManualDiscount = isManualDiscount

            line.itemNid = itemNid
            line.itemWriteoffNid = itemWriteoffNid
            line.qtyShippedWhenVoided = qtyShippedWhenVoided
            line.qtyShipped = qtyShipped
            line.qtyOrdered = qtyOrdered
            line.qtyLayerRoundingAdjustment = qtyLayerRoundingAdjustment
            line.crvContainerTypeNid = crvContainerTypeNid
            line.qtyDeliveryDriverAdjustment = qtyDeliveryDriverAdjustment
            line.qtyDeliveryDriverAdjustment = qtyDeliveryDriverAdjustment
            line.itemNameOverride = itemNameOverride
            line.unitPrice = unitPrice
            line.unitSplitCaseCharge = unitSplitCaseCharge
            line.isManualPrice = isManualPrice
            line.unitDeposit = unitDeposit
            line.isManualDeposit = isManualDeposit
            line.carrierDeposit = carrierDeposit
            line.bagCredit = bagCredit
            line.statePickupCredit = statePickupCredit
            line.unitFreight = unitFreight
            line.unitDeliveryCharge = unitDeliveryCharge
            line.qtyBackordered = qtyBackordered
            line.qtyDiscountedOnThisLine = qtyDiscountedOnThisLine
            line.isCloseDatedInMarket = isCloseDatedInMarket
            line.isManualDeposit = isManualDeposit
            line.basePricesAndPromosOnQtyOrdered = basePricesAndPromosOnQtyOrdered
            line.wasAutoCut = wasAutoCut
            line.mergeSequenceTag = mergeSequenceTag
            line.autoFreeGoodsLine = autoFreeGoodsLine
            line.isPreferredFreeGoodLine = isPreferredFreeGoodLine
            line.originalQtyShipped = originalQtyShipped
            line.originalItemWriteoffNid = originalItemWriteoffNid
            line.uniqueifier = uniqueifier
            line.wasDownloaded = wasDownloaded
            line.retailPrice = retailPrice
            line.editedRetailPrice = editedRetailPrice
            line.buildTo = buildTo
            line.count = count
            line.routeBookBuildTo = routeBookBuildTo
            line.pickAndShipDateCodes = pickAndShipDateCodes
            line.dateCode = dateCode
            line.parentSlsEmpNid = parentSlsEmpNid
            line.parentOrderedDate = parentOrderedDate
            line.CMAOnNid = CMAOnNid
            line.CTMOnNid = CTMOnNid
            line.CCFOnNid = CCFOnNid
            line.CMAOffNid = CMAOffNid
            line.CTMOffNid = CTMOffNid
            line.CCFOffNid = CCFOffNid
            line.CMAOnAmt = CMAOnAmt
            line.CTMOnAmt = CTMOnAmt
            line.CCFOnAmt = CCFOnAmt
            line.CMAOffAmt = CMAOffAmt
            line.CTMOffAmt = CTMOffAmt
            line.CCFOffAmt = CCFOffAmt
            line.commOverrideSlsEmpNid = commOverrideSlsEmpNid
            line.commOverrideDrvEmpNid = commOverrideDrvEmpNid
            line.qtyCloseDateRequested = qtyCloseDateRequested
            line.qtyCloseDateShipped = qtyCloseDateShipped
            line.preservePricing = preservePricing
            line.noteLink = noteLink
            line.seq = seq

            return line
        }

        func resetTokenVariablesAfterAddingOrderLine() {
            qtyBackordered = 0
            isCloseDatedInMarket = false
            qtyDiscounted = nil
            isManualPrice = false
            isManualDiscount = false
            isManualDeposit = false
            basePricesAndPromosOnQtyOrdered = false
            wasAutoCut = false
            pickAndShipDateCodes = nil
            dateCode = nil
            buildTo = nil
            count = nil
            routeBookBuildTo = nil
            itemNameOverride = nil
            CMAOnNid = nil
            CTMOnNid = nil
            CCFOnNid = nil
            CMAOffNid = nil
            CTMOffNid = nil
            CCFOffNid = nil
            CMAOnAmt = .zero
            CTMOnAmt = .zero
            CCFOnAmt = .zero
            CMAOffAmt = .zero
            CTMOffAmt = .zero
            CCFOffAmt = .zero
            commOverrideSlsEmpNid = nil
            commOverrideDrvEmpNid = nil
            qtyCloseDateRequested = nil
            qtyCloseDateShipped = nil
            qtyShippedWhenVoided = nil
            originalQtyShipped = nil
            preservePricing = false
            noteLink = 0
        }

        let order = MobileOrder()

        func processCommaCommand(v: [String]) {
            switch v[0] {
            case "DoNotChargeUnitFreight":
                order.doNotChargeUnitFreight = true
            case "DoNotChargeUnitDeliveryCharge":
                order.doNotChargeUnitDeliveryCharge = true
            case "IgnoreDeliveryTruckRestrictions":
                order.ignoreDeliveryTruckRestrictions = true
            case "SignatureVectors":
                order.signatureVectors = v[1] // SignatureVector.Deserialize(v[1]).ToArray()
            case "DriverSignatureVectors":
                order.driverSignatureVectors = v[1] // SignatureVector.Deserialize(v[1]).ToArray()
            case "PartOrderNumbers":
                for i in 1 ..< v.count {
                    if let orderNumber = Int(v[i]) {
                        order.orderNumbersForPartitioner.append(orderNumber)
                    }
                }
            case "PartDeliveryInfo":

                let isOffScheduleDelivery = v[1] == "1"
                if let driverNid = Int(v[2]), let deliveryDate = Date.fromDownloadedDate(v[3]) {
                    let x = MobileOrder.DeliveryInfoForPartitioning(isOffScheduleDelivery: isOffScheduleDelivery, driverNid: driverNid, deliveryDate: deliveryDate)
                    order.deliveryInfos.append(x)
                }
            case "IsOffScheduleDelivery":
                order.isOffScheduleDelivery = true
            case "QtyDiscounted":
                qtyDiscounted = Int(v[1])
            case "QtyBackordered":
                qtyBackordered = Int(v[1]) ?? 0
            case "IsCloseDatedInMarket":
                isCloseDatedInMarket = true
            case "IsManualPrice":
                isManualPrice = true
            case "IsManualDiscount":
                isManualDiscount = true
            case "IsManualDeposit":
                isManualDeposit = true
            case "IsManualRebate":
                // the mobile devices know nothing about supplier rebates, costs, excise taxes and GL Accounts - these are filled-in prior to posting the order into the SQL database (OrderDataLookup.cs in eostarTicket)

                // isManualRebate = true
                break
            case "BasePricesAndPromosOnQtyOrdered":
                basePricesAndPromosOnQtyOrdered = true
            case "WasAutoCut":
                wasAutoCut = true
            case "OriginalQtyShipped":
                originalQtyShipped = Int(v[1])
            case "OriginalItemWriteoffNid":
                originalItemWriteoffNid = Int(v[1])
            case "Uniqueifier":
                uniqueifier = Int(v[1]) ?? 0
            case "WasDownloaded":
                wasDownloaded = Int(v[1]) ?? 0 != 0
            case "IsSpecialPaymentTerms":
                order.isSpecialPaymentTerms = true

            case "PromoDate":
                order.promoDate = Date.fromDownloadedDate(v[1])
            case "Authenticated":
                order.authenticatedDate = Date.fromDownloadedDateTime(v[1])
                order.authenticatedByNid = Int(v[2])
            case "Delivered":
                order.deliveredDate = Date.fromDownloadedDateTime(v[1])
                order.deliveredByNid = Int(v[2])
            case "DeliveryDocument":
                order.deliveryDocumentDate = Date.fromDownloadedDateTime(v[1])
                order.deliveryDocumentByNid = Int(v[2])
            case "Dispatched":
                order.dispatchedDate = Date.fromDownloadedDateTime(v[1])
                order.dispatchedByNid = Int(v[2])
            case "EdiInvoice":
                order.ediInvoiceDate = Date.fromDownloadedDateTime(v[1])
                order.ediInvoiceByNid = Int(v[2])
            case "EdiPayment":
                order.ediPaymentDate = Date.fromDownloadedDateTime(v[1])
                order.ediPaymentByNid = Int(v[2])
            case "EdiShipNotice":
                order.ediShipNoticeDate = Date.fromDownloadedDateTime(v[1])
                order.ediShipNoticeByNid = Int(v[2])
            case "Entered":
                order.enteredDate = Date.fromDownloadedDateTime(v[1])
                order.enteredByNid = Int(v[2])
            case "FollowupInvoice":
                order.followupInvoiceDate = Date.fromDownloadedDateTime(v[1])
                order.followupInvoiceByNid = Int(v[2])
            case "Loaded":
                order.loadedDate = Date.fromDownloadedDateTime(v[1])
                order.loadedByNid = Int(v[2])
            case "Ordered":
                order.orderedDate = Date.fromDownloadedDateTime(v[1])
            // order.orderedByNid = Int(v[2])*/
            case "Palletized":
                order.palletizedDate = Date.fromDownloadedDateTime(v[1])
                order.palletizedByNid = Int(v[2])
            case "PickList":
                order.pickListDate = Date.fromDownloadedDateTime(v[1])
                order.pickListByNid = Int(v[2])
            case "Shipped":
                order.shippedDate = Date.fromDownloadedDateTime(v[1])
            // order.shippedByNid = Int(v[2])*/

            case "Staged":
                order.stagedDate = Date.fromDownloadedDateTime(v[1])
                order.stagedByNid = Int(v[2])
            case "Verified":
                order.verifiedDate = Date.fromDownloadedDateTime(v[1])
                order.verifiedByNid = Int(v[2])
            case "Voided":
                order.voidedDate = Date.fromDownloadedDateTime(v[1])
                order.voidedByNid = Int(v[2])
            case "LoadNumber":
                order.loadNumber = Int(v[1])
            case "PickAndShipDateCodes":
                pickAndShipDateCodes = v[1 ..< v.count].joined(separator: ",")
            case "DateCode":
                dateCode = Date.fromDownloadedDate(v[1])
            case "BagCredit":
                bagCredit = MoneyWithoutCurrency(v[1]) ?? .zero
            case "StatePickupCredit":
                statePickupCredit = MoneyWithoutCurrency(v[1]) ?? .zero
            case "ToEquipNid":
                order.toEquipNid = Int(v[1])
            case "IsVendingReplenishment":
                order.isVendingReplenishment = v[1].lowercased() == "true"
            case "ReplenishmentVendTicketNumber":
                order.replenishmentVendTicketNumber = Int(v[1])
            case "IsCoopDeliveryPoint":
                order.isCoopDeliveryPoint = v[1] == "1"
            case "CoopCusNid":
                order.coopCusNid = Int(v[1])
            case "DoNotOptimizePalletsWithLayerRounding":
                order.doNotOptimizePalletsWithLayerRounding = v[1] == "1"

            case "CMAOnNid":
                CMAOnNid = Int(v[1])
            case "CTMOnNid":
                CTMOnNid = Int(v[1])
            case "CCFOnNid":
                CCFOnNid = Int(v[1])
            case "CMAOffNid":
                CMAOffNid = Int(v[1])
            case "CTMOffNid":
                CTMOffNid = Int(v[1])
            case "CCFOffNid":
                CCFOffNid = Int(v[1])
            case "CMAOnAmt":
                CMAOnAmt = MoneyWithoutCurrency(v[1]) ?? .zero
            case "CTMOnAmt":
                CTMOnAmt = MoneyWithoutCurrency(v[1]) ?? .zero
            case "CCFOnAmt":
                CCFOnAmt = MoneyWithoutCurrency(v[1]) ?? .zero
            case "CMAOffAmt":
                CMAOffAmt = MoneyWithoutCurrency(v[1]) ?? .zero
            case "CTMOffAmt":
                CTMOffAmt = MoneyWithoutCurrency(v[1]) ?? .zero
            case "CCFOffAmt":
                CCFOffAmt = MoneyWithoutCurrency(v[1]) ?? .zero
            case "CommOverrideSlsEmpNid":
                commOverrideSlsEmpNid = Int(v[1])
            case "CommOverrideDrvEmpNid":
                commOverrideDrvEmpNid = Int(v[1])
            case "QtyCloseDateRequested":
                qtyCloseDateRequested = Int(v[1])
            case "QtyCloseDateShipped":
                qtyCloseDateShipped = Int(v[1])

            case "PalletLineChange":
                break // order.handheldDeliveryAdjustments.Add(DeliveryAdjustment.FromBlobForPalletLineChange(v[1]))
            case "ReturnsValidated":
                order.returnsValidated = true
            case "POAAmount":
                order.POAAmount = MoneyWithoutCurrency(v[1]) ?? .zero
            case "POAExpected":
                order.POAExpected = MoneyWithoutCurrency(v[1]) ?? .zero
            case "IncludeChargeOrderInTotalDue":
                order.includeChargeOrderInTotalDue = true
            case "VerifiedPalletLine":
                break // order.verifiedPalletLines.Add(VerifiedPalletLine.FromBlob(v[1]))
            case "DeliveryAdjustment":
                break // order.handheldDeliveryAdjustments.Add(DeliveryAdjustment.FromBlob(v[1]))
            case "QtyLayerRoundingAdjustment":
                qtyLayerRoundingAdjustment = Int(v[1]) ?? 0
            case "CrvContainerTypeNid":
                crvContainerTypeNid = Int(v[1]) ?? 0
            case "DeliverySequence":
                order.deliverySequence = Int(v[1])
            case "SalesTaxStateB":
                order.salesTaxStateB = MoneyWithoutCurrency(v[1]) ?? .zero
            case "SalesTaxStateC":
                order.salesTaxStateC = MoneyWithoutCurrency(v[1]) ?? .zero
            case "QtyShippedWhenVoided":
                qtyShippedWhenVoided = Int(v[1])
            case "PreservePricing":
                preservePricing = true
            case "NoteLink":
                noteLink = Int(v[1]) ?? 0
            case "OrderDEXStatus":
                order.orderDEXStatus = MobileOrder.eOrderDEXStatus(rawValue: Int(v[1]) ?? 0)
            case "IsForPlanogramReset":
                order.isForPlanogramReset = true
            case "ManualHold":
                order.manualHold = true

            default: break
            }
        }

        func processToken(tokenType: MobileOrder.orderTokenType, field: TokenService.Token) {
            switch tokenType {
            // case .VAT:
            //     order.VAT = field.decimal4Value
            // case .Levy:
            //     order.levy = field.decimal4Value

            case .CompanyNid:
                order.companyNid = field.intValue
            case .DeliveryChargeNid:
                order.deliveryChargeNid = field.intValue
            case .IsAutoDeliveryCharge:
                order.isAutoDeliveryCharge = field.boolValue
            case .IsEarlyPay:
                order.isEarlyPay = field.boolValue
            case .EarlyPayDiscountAmt:
                order.earlyPayDiscountAmt = field.money2Value ?? .zero
            case .TermDiscountDays:
                order.termDiscountDays = field.intValue
            case .TermDiscountPct:
                order.termDiscountPct = field.intValue
            case .HeldStatus:
                order.heldStatus = field.boolValue
            case .VoidedStatus:
                order.isVoided = field.boolValue
            case .DeliveredStatus:
                order.deliveredStatus = field.boolValue
            case .OrderType:
                order.orderType = MobileOrder.eOrderType.init(rawValue: field.intValue)
                order.isNewOrder = order.orderType == MobileOrder.eOrderType.FreshOfftruckOrder || order.orderType == MobileOrder.eOrderType.FreshPresellOrder
            case .IsFromDistributor:
                order.isFromDistributor = field.boolValue
            case .IsToDistributor:
                order.isToDistributor = field.boolValue
            case .IsHotShot:
                order.isHotShot = field.boolValue
            case .NumberSummarized:
                order.numberSummarized = field.intValue
            case .SummaryOrderNumber:
                order.summaryOrderNumber = field.intValue
            case .CoopTicketNumber:
                order.coopTicketNumber = field.intValue
            case .ShipAdr1:
                order.shipAdr1 = field.stringValue
            case .ShipAdr2:
                order.shipAdr2 = field.stringValue
            case .ShipCity:
                order.shipCity = field.stringValue
            case .ShipState:
                order.shipState = field.stringValue
            case .ShipZip:
                order.shipZip = field.stringValue
            case .OrderNumber:
                order.orderNumber = field.intValue
            case .WhseNid:
                order.whseNid = field.intValue
            case .TrkNid:
                order.trkNid = field.intValue
            case .CusNid:
                order.toCusNid = field.intValue
            case .DeliveryDate:
                order.deliveredDate = Date.fromDownloadedDate(field.stringValue)
            case .EntryTime:
                // legacyEntryTime = DateTime.ParseExact(field.stringValue, "yyyy-MM-dd HH:mm:ss", null)  - this is a really old token (not used any more) - pre 2011
                break
            case .PushOffDate:
                order.pushOffDate = Date.fromDownloadedDate(field.stringValue)
            case .DriverNid:
                order.drvEmpNid = field.intValue
            case .SlsEmpNid:
                order.slsEmpNid = field.intValue
            case .OrderTypeNid:
                order.orderTypeNid = field.intValue
            case .IsBillAndHold:
                order.isBillAndHold = field.boolValue
            case .PaymentTermsNid:
                order.paymentTermsNid = field.intValue
            case .IsBulkOrderFlag:
                order.isBulkOrder = field.boolValue
            case .IsChargeFlag:
                order.isCharge = field.boolValue
            case .TaxableFlag:
                order.isTaxable = field.boolValue
            case .UsedCombinedForm:
                order.usedCombinedForm = field.boolValue
            case .EFTFlag:
                order.isEft = field.boolValue
            case .PONum:
                order.poNumber = field.stringValue
            case .PlacedWith:
                order.takenFrom = field.stringValue
            case .DeliveryNote:
                order.invoiceNote = field.stringValue
            case .PackNote:
                order.packNote = field.stringValue
            case .SerializedItems:
                order.serializedItems = field.stringValue
            case .ReceivedBy:
                order.receivedBy = field.stringValue
            case .PushOffReason:
                order.pushOffReason = field.stringValue
                order.skipReason = field.stringValue
            case .VoidReason:
                order.voidReason = field.stringValue
                order.skipReason = field.stringValue
            case .OffInvoiceDiscPct:
                order.offInvoiceDiscPct = field.intValue
            case .DiscountAmt:
                order.discountAmt = field.money4Value ?? .zero
            case .TotalTax:
                order.salesTax = field.money4Value ?? .zero
            case .SalesTaxCounty:
                order.salesTaxCounty = field.money4Value ?? .zero
            case .SalesTaxState:
                order.salesTaxState = field.money4Value ?? .zero
            case .SalesTaxLocal:
                order.salesTaxLocal = field.money4Value ?? .zero
            case .SalesTaxCity:
                order.salesTaxCity = field.money4Value ?? .zero
            case .SalesTaxWholesale:
                order.salesTaxWholesale = field.money4Value ?? .zero
            case .TotalFreight:
                order.totalFreight = field.money4Value ?? .zero
            case .IsExistingOrder:
                order.isExistingOrder = field.boolValue
            case .PrintedReviewInvoice:
                order.printedReviewInvoice = field.boolValue
            case .QtyOrdered:
                qtyOrdered = field.intValue
            case .QtyShipped:
                qtyShipped = field.intValue
            case .QtyDeliveryDriverAdjustment:
                qtyDeliveryDriverAdjustment = field.intValue
            case .IsNewlyAddedItem:
                // isNewlyAddedItem = field.boolValue
                break
            case .RetailPrice:
                retailPrice = field.money2Value ?? .zero
            case .EditedRetailPrice:
                editedRetailPrice = field.boolValue
            case .RetailDateCode: // KJQ 5/11/10 ... only used on mobile devices
                // retailDateCode = Date.fromDownloadedDate(field.stringValue)
                break
            case .RetailDateCodeQty: // KJQ 5/11/10 ... only used on mobile devices
                // retailDateCodeQty = field.intValue
                break
            case .EditedRetailDateCodeEntry: // KJQ 5/11/10 ... only used on mobile devices
                // editedRetailDateCodeEntry = field.boolValue
                break
            case .QtyShippedWhenOpened: // CDF 1/20/12 ... only used on mobile devices
                // qtyShippedWhenOpened = field.intValue
                break
            case .UnitPrice:
                unitPrice = field.money4Value ?? .zero
            case .UnitDisc:
                unitDisc = field.money4Value ?? .zero
            case .UnitSplitCaseCharge:
                unitSplitCaseCharge = field.money4Value ?? .zero
            case .UnitDeposit:
                unitDeposit = field.money4Value ?? .zero
            case .CarrierDeposit:
                carrierDeposit = field.money4Value ?? .zero
            case .UnitFreight:
                unitFreight = field.money2Value ?? .zero
            case .UnitDeliveryCharge:
                unitDeliveryCharge = field.money2Value ?? .zero
            case .Promo1Nid:
                promo1Nid = field.intValue
            case .ItemWriteoffNid:
                itemWriteoffNid = field.intValue
            case .ItemNameOverride:
                itemNameOverride = field.stringValue
            case .BuildTo:
                buildTo = field.intValue
            case .Count:
                count = field.decimal2Value
            case .RouteBookBuildTo:
                routeBookBuildTo = field.decimal2Value
            case .ShelfCount:
                // shelfCount = field.decimal2Value
                break
            case .IsNewBuildTo:
                // isNewBuildTo = field.boolValue
                break
            case .MergeSequenceTag:
                mergeSequenceTag = field.intValue
            case .AutoFreeGoodsLine:
                autoFreeGoodsLine = field.boolValue
            case .IsPreferredFreeGoodLine:
                isPreferredFreeGoodLine = field.boolValue
            case .ParentOrderedDate:
                parentOrderedDate = Date.fromDownloadedDateOrDateTime(field.stringValue)
            case .ParentSlsEmpNid:
                parentSlsEmpNid = field.intValue
            case .VoidReasonNid:
                order.voidReasonNid = field.intValue

            case .ItemNid:
                break
            case .CommaCommand:
                break
            }
        }

        let tokenizerService = TokenService(blob)

        for token in tokenizerService.tokens {
            guard let tokenType = MobileOrder.orderTokenType.init(rawValue: token.tokenType) else {
                continue
            }

            switch tokenType {
            case .ItemNid:
                let itemNid = token.intValue
                let line = getOrderLine(itemNid: itemNid, seq: order.lines.count)
                order.lines.append(line)
                resetTokenVariablesAfterAddingOrderLine()

            case .CommaCommand:
                processCommaCommand(v: token.stringValue.components(separatedBy: ","))

            default:
                processToken(tokenType: tokenType, field: token)
            }
        }

        return order
    }
}
