//
//  eToken.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 8/31/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

// mpr: obsolete tokens
// case IsNewlyAddedItem = "]"
// case zzz_AutoPrice = "E"
// case zzz_Promo1Disc = "H"
// case EntryTime = "t" // not used (only seen in Legacy - pre 2011 - MobileUploads)
// case BuildTo = "U" // mpr: obsolete
// case Count = "V" // mpr: obsolete
// case RouteBookBuildTo = "{" // mpr: obsolete
// case ShelfCount = "^" // mpr: obsolete
// case IsNewBuildTo = "~" // mpr: obsolete
// case RetailPrice = "}" // mpr: we maintain this info on the RetailerInfo (walkaround) info
// case EditedRetailPrice = "+" // mpr: we maintain this info on the RetailerInfo (walkaround) info
// case RetailDateCode = "5" // KJQ 5/11/10 ... only used on mobile devices
// case RetailDateCodeQty = "6" // KJQ 5/11/10 ... only used on mobile devices
// case EditedRetailDateCodeEntry = "7" // KJQ 5/11/10 ... only used on mobile devices
// case ParentOrderedDate = "!"
// case ParentSlsEmpNid = "-"
// case QtyShippedWhenOpened = "/" // CDF 1/20/12 ... only used on mobile devices
// VAT = " " // TODO FIGURE OUT TOKEN
// Levy = " ' // TODO FIGURE OUT TOKEN

extension MobileOrderDecoder {
    public enum tokenType: String { // aka 'eToken.cs'
 
        case OrderNumber = "a"
        case CusNid = "b"
        case DeliveryDate = "c"
        case DriverNid = "d"
        case TaxableFlag = "e"
        case PONum = "f"
        case PlacedWith = "g"
        case DeliveryNote = "h"
        case DiscountAmt = "i"
        case TotalTax = "j"
        case OrderType = "k"
        case IsExistingOrder = "l"
        case ReceivedBy = "m"
        case IsChargeFlag = "n"
        case PaymentTermsNid = "o"
        case OffInvoiceDiscPct = "p"
        case TotalFreight = "q"
        case TrkNid = "r"
        case SlsEmpNid = "s"
        case PushOffDate = "u"
        case VoidedStatus = "v"
        case WhseNid = "w"
        case DeliveredStatus = "x"
        case VoidReason = "y"
        case PushOffReason = "z"
        case PackNote = "%"
        
        case ItemNid = "A" // using CAPS for tokens that are related to line-items (no real reason for this ...)
        case QtyOrdered = "B"
        case UnitPrice = "C"
        case UnitDisc = "D"
        case UnitSplitCaseCharge = "\\"
        
        case Promo1Nid = "F"
        case ItemWriteoffNid = "J"
        case HeldStatus = "K"
        case ItemNameOverride = "L"
        case IsFromDistributor = "M"
        case IsToDistributor = "N"
        case SerializedItems = "O"
        case NumberSummarized = "P"
        case SummaryOrderNumber = "Q"
        case QtyShipped = "R"
        case UnitDeposit = "S"
        case CoopTicketNumber = "0"
        case ShipAdr1 = "_"
        case ShipAdr2 = "<"
        case ShipCity = ">"
        case ShipState = "&"
        case ShipZip = "="
        case IsHotShot = "π"
        
        case UnitFreight = "G"
        case UnitDeliveryCharge = "I"
        
        case EFTFlag = "T"
        case IsEarlyPay = "W"
        case EarlyPayDiscountAmt = "X"
        case TermDiscountDays = "Y"
        case TermDiscountPct = "Z"
        
        case OrderTypeNid = "@"
        
        case SalesTaxCounty = "1"
        case SalesTaxState = "2"
        case SalesTaxLocal = "3"
        case SalesTaxCity = "4"
        case SalesTaxWholesale = "."
        
        case PrintedReviewInvoice = "?"
        case IsBulkOrderFlag = "*"
        case IsBillAndHold = "|"
        
        case IsAutoDeliveryCharge = "("
        case DeliveryChargeNid = ")"
        case QtyDeliveryDriverAdjustment = "["
        case UsedCombinedForm = "#"
        case MergeSequenceTag = "$"
        case AutoFreeGoodsLine = "`"
        
        case CarrierDeposit = "8"
        case IsPreferredFreeGoodLine = "9"
        case VoidReasonNid = ":"
        case CompanyNid = ";"
        
        //case CommaCommand = "," // the following commands all start with "," - a concession to the older c# switch statement
        
        case DoNotChargeUnitFreight = ",DoNotChargeUnitFreight"
        case DoNotChargeUnitDeliveryCharge = ",DoNotChargeUnitDeliveryCharge"
        case IgnoreDeliveryTruckRestrictions = ",IgnoreDeliveryTruckRestrictions"
        case SignatureVectors = ",SignatureVectors"
        case DriverSignatureVectors = ",DriverSignatureVectors"
        case PartOrderNumbers = ",PartOrderNumbers"
        case PartDeliveryInfo = ",PartDeliveryInfo"
        case IsOffScheduleDelivery = ",IsOffScheduleDelivery"
        case QtyDiscounted = ",QtyDiscounted"
        case QtyBackordered = ",QtyBackordered"
        case IsCloseDatedInMarket = ",IsCloseDatedInMarket"
        case IsManualPrice = ",IsManualPrice"
        case IsManualDiscount = ",IsManualDiscount"
        case IsManualDeposit = ",IsManualDeposit"
        case IsManualRebate = ",IsManualRebate"
        case BasePricesAndPromosOnQtyOrdered = ",BasePricesAndPromosOnQtyOrdered"
        case WasAutoCut = ",WasAutoCut"
        case Uniqueifier = ",Uniqueifier"
        case WasDownloaded = ",WasDownloaded"
        case IsSpecialPaymentTerms = ",IsSpecialPaymentTerms"
        case PromoDate = ",PromoDate"
        case Authenticated = ",Authenticated"
        case Delivered = ",Delivered"
        case DeliveryDocument = ",DeliveryDocument"
        case Dispatched = ",Dispatched"
        case EdiInvoice = ",EdiInvoice"
        case EdiPayment = ",EdiPayment"
        case EdiShipNotice = ",EdiShipNotice"
        case Entered = ",Entered"
        case FollowupInvoice = ",FollowupInvoice"
        case Loaded = ",Loaded"
        case Ordered = ",Ordered"
        case Palletized = ",Palletized"
        case PickList = ",PickList"
        case Shipped = ",Shipped"
        case Staged = ",Staged"
        case Verified = ",Verified"
        case Voided = ",Voided"
        case LoadNumber = ",LoadNumber"
        case PickAndShipDateCodes = ",PickAndShipDateCodes"
        case BagCredit = ",BagCredit"
        case StatePickupCredit = ",StatePickupCredit"
        case ToEquipNid = ",ToEquipNid"
        case IsVendingReplenishment = ",IsVendingReplenishment"
        case ReplenishmentVendTicketNumber = ",ReplenishmentVendTicketNumber"
        case IsCoopDeliveryPoint = ",IsCoopDeliveryPoint"
        case CoopCusNid = ",CoopCusNid"
        case DoNotOptimizePalletsWithLayerRounding = ",DoNotOptimizePalletsWithLayerRounding"
        case CMAOnNid = ",CMAOnNid"
        case CTMOnNid = ",CTMOnNid"
        case CCFOnNid = ",CCFOnNid"
        case CMAOffNid = ",CMAOffNid"
        case CTMOffNid = ",CTMOffNid"
        case CCFOffNid = ",CCFOffNid"
        case CMAOnAmt = ",CMAOnAmt"
        case CTMOnAmt = ",CTMOnAmt"
        case CCFOnAmt = ",CCFOnAmt"
        case CMAOffAmt = ",CMAOffAmt"
        case CTMOffAmt = ",CTMOffAmt"
        case CCFOffAmt = ",CCFOffAmt"
        case CommOverrideSlsEmpNid = ",CommOverrideSlsEmpNid"
        case CommOverrideDrvEmpNid = ",CommOverrideDrvEmpNid"
        case QtyCloseDateRequested = ",QtyCloseDateRequested"
        case QtyCloseDateShipped = ",QtyCloseDateShipped"
        case ReturnsValidated = ",ReturnsValidated"
        case POAAmount = ",POAAmount"
        case POAExpected = ",POAExpected"
        case IncludeChargeOrderInTotalDue = ",IncludeChargeOrderInTotalDue"
        case QtyLayerRoundingAdjustment = ",QtyLayerRoundingAdjustment"
        case CrvContainerTypeNid = ",CrvContainerTypeNid"
        case DeliverySequence = ",DeliverySequence"
        case SalesTaxStateB = ",SalesTaxStateB"
        case SalesTaxStateC = ",SalesTaxStateC"
        case QtyShippedWhenVoided = ",QtyShippedWhenVoided"
        case PreservePricing = ",PreservePricing"
        case NoteLink = ",NoteLink"
        case OrderDEXStatus = ",OrderDEXStatus"
        case IsForPlanogramReset = ",IsForPlanogramReset"
        case ManualHold = ",ManualHold"

    }
}
